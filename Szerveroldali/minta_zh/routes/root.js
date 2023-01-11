const { StatusCodes } = require("http-status-codes");
const S = require('fluent-json-schema');
const { Sequelize, sequelize, User, Playlist, Track } = require("../models");
const { ValidationError, DatabaseError, Op } = Sequelize;

module.exports = function (fastify, opts, next) {

    // 3. feladat: GET /tracks (0.5 pont)
    // Lekéri az összes zeneszámot.
    fastify.get("/tracks", async (request, reply) => {
        reply.send(await Track.findAll());
    });

    //4. feladat: GET /tracks/:id (0.5 pont)
    // Lekér egy adott zeneszámot.
    fastify.get("/tracks/:id", async (request, reply) => {
        const { id } = request.params;
        const track = await Track.findByPk(id);

        if (!track) {
            return reply.status(404).send();
        }

        reply.send(track);
    });
    
    

    //5. feladat: POST /tracks (1 pont)
    // Létrehoz egy új zeneszámot.
    fastify.post("/tracks", async (request, reply) => {
        const track = await Track.create(request.body);
        reply.status(201).send(track);
    });

    //6. feladat: PUT /tracks/:id (1 pont)
    // Módosít egy meglévő zeneszámot. Csak azokat a mezőket módosítja, amiket felküldünk, 
    // a többit változatlanul hagyja.
    fastify.put("/tracks/:id", async (request, reply) => {
        const { id } = request.params;
        const track = await Track.findByPk(id);

        if (!track) {
            return reply.status(404).send();
        }

        await track.update(request.body);

        reply.send(track);
    });

    //     7. feladat: DELETE /tracks/:id (1 pont)
    // Töröl egy meglévő zeneszámot.
    // Minta kérés: DELETE http://localhost:4000/tracks/23
    // Válasz megfelelő kérés esetén: 200 OK
    // Válasz, ha a megadott id-vel nem létezik zeneszám: 404 NOT FOUND
    fastify.delete("/tracks/:id", async (request, reply) => {
        const { id } = request.params;
        const track = await Track.findByPk(id);
//  
        if (!track) {
            return reply.status(404).send();
        }

        await track.destroy();

        reply.send();
    });

    //     8. feladat: POST /login (2 pont)
    // Hitelesítés. 
    // Nincs semmilyen jelszókezelés, csak a felhasználónevet kell felküldeni a request body-ban. 
    // Ha a megadott felhasználónévvel létezik fiók az adatbázisban, 
    //  azt sikeres loginnak vesszük és kiállítjuk a tokent. 
    // A user-t bele kell rakni a token payload-jába! 
    // A token aláírásához HS256 algoritmust használj! 
    // A titkosító kulcs értéke "secret" legyen!
    fastify.post("/login", {
        schema: {
            // body: {
            //     type: 'object',
            //     required: ['email'],
            //     properties: {
            //         email: {
            //             type: 'string'
            //         }
            //     }
            // }
            body: S.object().prop('email', S.string().format(S.FORMATS.EMAIL).required())
        }
    }, async (request, reply) => {
        const { email } = request.body;

        const user = await User.findOne({
            where: {
                // ugyanaz, mint az email: email,
                email,
            }
        });

        if (!user) {
            return reply.status(404).send();
        }

        const token = fastify.jwt.sign(user.toJSON());

        reply.send({ token })
    });


    //     9. feladat: GET /my-playlists (1 pont)
    // Megadja a bejelentkezett felhasználóhoz tartozó lejátszási listákat. 
    // Értelemszerűen a végpont hitelesített, hiszen ehhez tudnunk kell, 
    //  hogy ki a bejelentkezett felhasználó.
    fastify.get("/my-playlists", { onRequest: [fastify.auth] }, async (request, reply) => {
        // await Playlist.findAll({
        //     where: {
        //         UserId: request.user.id,
        //     }
        // });

        const user = await User.findByPk(request.user.id);
        reply.send(await user.getPlaylists());
    });

    
    //     10. feladat: POST /my-playlists (1 pont)
    // Új lejátszási lista létrehozása a bejelentkezett felhasználóhoz. A végpont hitelesített.
    fastify.post("/my-playlists", { onRequest: [fastify.auth] }, async (request, reply) => {
        // await Playlist.create({
        //     ...request.body,
        //     UserId: request.user.id,
        // })

        const user = await User.findByPk(request.user.id);
        reply.status(201).send(await user.createPlaylist(request.body));
    });


    //     11. feladat: POST /my-playlists/:id/add-tracks (6 pont)
    // Zeneszám(ok) hozzárendelése a bejelentkezett felhasználó megadott lejátszási listájához 
    // (adatbázis szintű reláció megteremtése két egyébként már létező entitás esetén). 
    // A végpont hitelesített.
    fastify.post("/my-playlists/:id/add-tracks", {
        onRequest: [fastify.auth],
        schema: {
            body: S.object().prop('tracks', S.array().required())
        }
    }, async (request, reply) => {
        const user = await User.findByPk(request.user.id);

        const playlist = await Playlist.findByPk(request.params.id);
        if (!playlist) {
            return reply.status(404).send();
        }

        // meg lehetne nézni a UserId mező stimmel-e
        // playlist.UserId == user.id
        if (!(await user.hasPlaylist(playlist))) {
            return reply.status(403).send();
        }

        const invalidTracks = [], alreadyAdded = [], addedTracks = [];

        for (const id of request.body.tracks) {
            const track = await Track.findByPk(id);

            if (!track) {
                invalidTracks.push(id);
            } else if (await playlist.hasTrack(track)) {
                alreadyAdded.push(id)
            } else {
                addedTracks.push(id);
                // await playlist.addTrack(track)
            }
        }

        await playlist.addTracks(addedTracks);

        return {
            invalidTracks,
            alreadyAdded,
            addedTracks,
            playlist: {
                ...playlist.toJSON(),
                tracks: await playlist.getTracks({
                    joinTableAttributes: [],
                })
            }
        }

    });

    //  12. feladat: POST /my-playlists/:id/remove-tracks (6 pont)
    //   Zeneszám(ok) eltávolítása a bejelentkezett felhasználó megadott lejátszási listájáról 
    //    (adatbázis szintű reláció megszüntetése). 
    //   A végpont hitelesített.
    fastify.post("/my-playlists/:id/remove-tracks", {
        onRequest: [fastify.auth],
        schema: {
            body: S.object().prop('tracks', S.array().required())
        }
    }, async (request, reply) => {
        const user = await User.findByPk(request.user.id);

        const playlist = await Playlist.findByPk(request.params.id);
        if (!playlist) {
            return reply.status(404).send();
        }

        if (!(await user.hasPlaylist(playlist))) {
            return reply.status(403).send();
        }

        const invalidTracks = [], skippedTracks = [], removedTracks = [];

        for (const id of request.body.tracks) {
            const track = await Track.findByPk(id);

            if (!track) {
                invalidTracks.push(id);
            } else if (!(await playlist.hasTrack(track))) {
                skippedTracks.push(id)
            } else {
                removedTracks.push(id);
                // await playlist.removeTrack(track)
            }
        }

        await playlist.removeTracks(removedTracks);

        return {
            invalidTracks,
            skippedTracks,
            removedTracks,
            playlist: {
                ...playlist.toJSON(),
                tracks: await playlist.getTracks({
                    joinTableAttributes: [],
                })
            }
        }

    });

    // 13. feladat: GET /playlists/:id/tracks (6 pont)
    //  Lekéri a megadott playlist-hez tartozó track-eket. 
    //  A végpont "opcionálisan" hitelesített, hiszen ha nyilvános lejátszási listát kérünk le 
    //   (emlékeztető: private adattag), akkor azt bárkinek (egy vendégnek is) megjeleníthetjük, 
    //   de ha a lejátszási lista privát, akkor ellenőriznünk kell, 
    //   hogy a tulajdonosa küldte-e a kérést, 
    //   hiszen ő megnézheti, de egy vendég/más felhasználók nem.
    fastify.get("/playlists/:id/tracks", async (request, reply) => {
        // Ha sikerül a validáció, akkor berakja a request.user-be a payloadot,
        // egyébként nem
        try {
            await request.jwtVerify()
        } catch (err) { }

        const playlist = await Playlist.findByPk(request.params.id);
        if (!playlist) {
            return reply.status(404).send();
        }

        if (playlist.private && (!request.user || request.user.id != playlist.UserId)) {
            return reply.status(403).send();
        }

        // reply.send(
        //     await playlist.getTracks({
        //         attributes: {
        //             include: [
        //                 [sequelize.fn('TIME', sequelize.col('length'), "unixepoch"), 'lengthFormatted']
        //             ],
        //             exclude: ['createdAt', 'updatedAt']
        //         },
        //         order: 'shuffle' in request.query ? sequelize.random() : undefined
        //     })
        // )

        const options = {
            attributes: {
                exclude: ['createdAt', 'updatedAt']
            },

            joinTableAttributes: [],
        }

        if ('shuffle' in request.query) {
            options.order = sequelize.random();
        }

        const tracks = await playlist.getTracks(options);

        reply.send(
            tracks.map(track => {
                track = track.toJSON();

                track.lengthFormatted = new Date(
                    track.length * 1000
                )
                    .toUTCString()
                    .substring(17, 17+8);

                return track;
            })
        )

    });

    fastify.addHook('onError', async (request, reply, error) => {
        // Ha valamilyen Sequelize-os validációs hiba történt, akkor rossz volt a request
        if (error instanceof ValidationError || error instanceof DatabaseError) {
            reply.status(400).send();
        }
    })



    // // http://127.0.0.1:4000/
    // fastify.get("/", async (request, reply) => {
    //     reply.send({ message: "Gyökér végpont" });
    //     // * A send alapból 200 OK állapotkódot küld, vagyis az előző sor ugyanaz, mint a következő:
    //     // reply.status(StatusCodes.OK).send({ message: "Gyökér végpont" });
    // });

    // // http://127.0.0.1:4000/auth-protected
    // fastify.get("/auth-protected", { onRequest: [fastify.auth] }, async (request, reply) => {
    //     reply.send({ user: request.user });
    // });

    next();
};

module.exports.autoPrefix = "/";
