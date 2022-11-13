<?php

namespace Database\Seeders;

// use Illuminate\Database\Console\Seeds\WithoutModelEvents;
use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\Hash;

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
                    'email' => 'user' . $i . '@szerveroldali.hu'
                ])
            );
        }
        $users->add(
            \App\Models\User::factory()->create([
                'email' => 'admin@szerveroldali.hu',
                'password' => Hash::make('adminpwd'),
                'is_admin' => true,
            ])
        );

        $items = \App\Models\Item::factory(rand(5,10))->create();
        $labels = \App\Models\Label::factory(rand(3,8))->create();


        $items->each( function ($item) use (&$labels, &$users) {
            $post_comments = \App\Models\Comment::factory(rand(2,9))->create();

            $post_comments->each( function ($comment) use (&$users){
                $comment->author()->associate( $users->random() )->save();
            } );

            $item->comments()->saveMany( $post_comments );

            $item->labels()->sync(
                $labels->random( rand(1, $labels->count()) )
            );
        } );

    }
}
