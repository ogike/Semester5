<?php

namespace Database\Factories;

use Illuminate\Database\Eloquent\Factories\Factory;

/**
 * @extends \Illuminate\Database\Eloquent\Factories\Factory<\App\Models\Item>
 */
class ItemFactory extends Factory
{
    /**
     * Define the model's default state.
     *
     * @return array<string, mixed>
     */
    public function definition()
    {
        return [
            // $table->string('name');
            'name' => fake()->word(),
            // $table->text('description');
            'description' => fake()->text(100),
            // $table->date('obtained');
            'obtained' => fake()->date('Y-m-d'),
            // $table->string('image')->nullable();
            'image' => fake()->imageUrl(320, 320, 'item', true, null, false, 'png'),
        ];
    }
}
