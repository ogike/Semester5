<?php

namespace App\Http\Controllers;

use App\Models\Category;
use App\Models\Post;
use App\Models\User;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Redirect;
use Illuminate\Support\Facades\Storage;
use Illuminate\Support\Facades\Session;
use Illuminate\Support\Str;

class PostController extends Controller
{
    /**
     * Display a listing of the resource.
     *
     * @return \Illuminate\Http\Response
     */
    public function index()
    {
        // Route::get('/posts', function () {
            return view('posts.index', [
                'users_count' => User::count(),
                'posts' => Post::all(),
                'categories' => Category::all(),
            ]);
        // });
    }

    /**
     * Show the form for creating a new resource.
     *
     * @return \Illuminate\Http\Response
     */
    public function create()
    {
        return view('posts.create', [
            'categories' => Category::all()
        ]);
    }

    /**
     * Store a newly created resource in storage.
     *
     * @param  \Illuminate\Http\Request  $request
     * @return \Illuminate\Http\Response
     */
    public function store(Request $request)
    {
        $validated = $request->validate( //input mezőnek részei
            [
                'name' => [ //tömbként is felsorolhatjuk, vag |-el elválasztva
                        'required',
                        'min:3',
                ],
                'description' => [
                    'nullable',
                    'max:255',
                ],
                'text' => [
                    'required',
                ],
                //maga a tömb
                'categories' => [
                    'nullable',
                    'array'
                ],
                //a tömb elemei
                'categories.*' => [
                    'numeric',
                    'integer',
                    'exists:categories,id' //ebben a táblában létezik e, ahol az id értéke egyenlő a kapott categories id-jével
                ],
                //fájlfeltöltés (itt a max size file esetén a fájlméretet veszi)
                'cover_image' => ['nullable', 'file', 'image', 'max:4096'],
            ],
            [
                [
                    'required' => 'This field is required',
                    'name.required' => 'Name is required',
                    'style.in' => "Invalid style",
                ]
            ]);

            $file_name = null;
            if($request->hasFile('cover_image')){
                $file = $request->file('cover_image');
                $file_name =  'ci_' . Str::random(10) . '.' . $file->getClientOriginalExtension();

                //ez a storage/app/public mappát éri el
                Storage::disk('public')->put(
                    $file_name,
                    $file->get()
                );
            }

            $post = Post::factory() -> create([
                'title' => $validated['title'],
                'description' => $validated['description'],
                'text' => $validated['text'],
                'cover_image_path' => $file_name,
            ]);

            //kategóriák hozzáadása (ha van)
            if(isset($validated['categories'])){
                $post->categories()->sync($validated['categories']);
            }

            Session::flash("post_created", $validated['title']);

            return Redirect::route('posts.create');
    }

    /**
     * Display the specified resource.
     *
     * @param  \App\Models\Post  $post
     * @return \Illuminate\Http\Response
     */
    public function show(Post $post)
    {
        return view('posts.show', [
            'post' => $post
        ]);
    }

    /**
     * Show the form for editing the specified resource.
     *
     * @param  \App\Models\Post  $post
     * @return \Illuminate\Http\Response
     */
    public function edit(Post $post)
    {
        //
    }

    /**
     * Update the specified resource in storage.
     *
     * @param  \Illuminate\Http\Request  $request
     * @param  \App\Models\Post  $post
     * @return \Illuminate\Http\Response
     */
    public function update(Request $request, Post $post)
    {
        //
    }

    /**
     * Remove the specified resource from storage.
     *
     * @param  \App\Models\Post  $post
     * @return \Illuminate\Http\Response
     */
    public function destroy(Post $post)
    {
        //
    }
}
