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
        $users_count = rand(5, 10);
        $users = collect();
        for ($i = 1; $i <= $users_count; $i++) {
            $users->add(
                \App\Models\User::factory()->create([
                    'email' => 'user' . $i . '@szerveroldali.hu',
                    'password' => 'password'
                ])
            );
        }
        $users->add(
            \App\Models\User::factory()->create([
                'email' => 'admin@szerveroldali.hu',
                'password' => 'adminpwd',
                'is_admin' => true,
            ])
        );

        $items = \App\Models\Item::factory(rand(5,10))->create();
        $labels = \App\Models\Label::factory(rand(3,8))->create();


        $items->each( function ($item) use (&$labels) {
            $post_comments = \App\Models\Comment::factory(rand(2,9))->create();

            // $item->aut
            //TODO: connections
        } );

    }
}
