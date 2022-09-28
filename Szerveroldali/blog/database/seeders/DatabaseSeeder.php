<?php

namespace Database\Seeders;

// use Illuminate\Database\Console\Seeds\WithoutModelEvents;
use Illuminate\Database\Seeder;

class DatabaseSeeder extends Seeder
{
    /**
     * Seed the application's database.
     *
     * @return void
     */
    public function run()
    {
        $users_count = rand(5,10);
        $users = collect();
        for ($i=2; $i <= $users_count; $i++) {
            $users->add(
                \App\Models\User::factory()->create([
                    'email' => 'user' . $i . '@szerveroldali.com'
                ])
            );
            # code...
        }
        $categories = \App\Models\Post::factory(rand(5,10))->create();
        $posts = \App\Models\Category::factory(rand(5,10))->create();

        //beadhoz teljes értékű seeder: modellek + kapcsolatok
        //relációk:

        //use (&): referenciaként átadni a lambda fgv-nek
        $posts->each( function ($post) use (&$users, &$categories) {
            //szerző
            $post->author()->associate($users->random())->save();

            //kategória
            $post->categories()->sync(
                $categories->random( rand(1,$categories->count()) )
            );
        } );

        // \App\Models\User::factory()->create([
        //     'name' => 'Test User',
        //     'email' => 'test@example.com',
        // ]);
    }
}
