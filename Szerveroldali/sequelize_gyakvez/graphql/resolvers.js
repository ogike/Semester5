const { User, Category, Post } = require('../models');
const auth = require('./auth');

module.exports = {
    Query: {
        //átvesszük a paraméterek objektét a schemának (második obj)
          // egyből destrukturáljuk is a {}-vel
          //eldobott első param: parent...?
        add: async (_, { x, y }) => x + y,

        hello: () => "Hello",

        test: (parent, params, context) => {
            console.log(Object.keys(context));
            return null;
        },

        categories: async () => await Category.findAll(),

        posts: async () => await Post.findAll(),

        who: auth(
            (parent, params, context) => `Hello ${context.user.email}`
        )
    },

    //modell alap mezőit automatikusan tudja rezolválni
    //  maga a kérés parentje át is adódik (maga a modell alapján objektum)
    //  kivétel: egymásba ágyazott relációk, külön fel kell oldani
    User: {
        posts: async (user) => await user.getPosts(),
    },
    Category: {
        posts: async (category) => await category.getPosts(),
    },
    Post: {
        categories: async (post) => await post.getCategories(),
        author: async (post) => await post.getUser(),
    },

    Mutation: {
        createPost: auth(
            async (_, { postInput }, context) => {
                return await Post.create({
                    ...postInput,
                    UserId: context.user.id,
                })
            }
        ),
        // editPost: auth(
        //     async (_, { id, post: postData }, context) => {
        //         const post = await Post.findByPk(id);

        //         if (!post) {
        //             throw new Error("Post not found")
        //         }

        //         if (post.UserId !== context.user.id) {
        //             // Illetéktelen módosítás, nem ő a szerző
        //             throw new Error("FORBIDDEN")
        //         }

        //         await post.update(postData)

        //         return post
        //     }
        // )
        editPost: auth(
            //what is this post: postData, user: userData thingy
            async (_, { id, post: postData }, { user: userData }) => {
                const post = await Post.findByPk(id);

                if (!post) {
                    throw new Error("Post not found")
                }

                const user = await User.findByPk(userData.id);

                if (!(await user.hasPost(post))) {
                    // Illetéktelen módosítás, nem ő a szerző
                    throw new Error("FORBIDDEN")
                }

                await post.update(postData)

                return post
            }
        )
    }
}

/* 

{
  hello
  add(x: 1, y: 1)
  posts {
    title
    categories {
      id
      name
      posts {
        title
      }
    }
  }
}

mutation {
  createPost(post: {
    title: "Cim", 
    text: "Text"
  }) {
    id,
    title,
    author {
      email
    }
  }
}

mutation {
  editPost(
    id: 2,
    post: {
      title: "Cim2", 
      text: "Text"
    }
  ) {
    id,
    title,
    author {
      email
    }
  }
}

*/