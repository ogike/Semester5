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
            'name' => fake()->word(),
            'description' => fake()->paragraphs(4, true),
            'obtained' => fake()->date('Y-m-d'),
            'image' => fake()->imageUrl(320, 320, 'item', true, null, false, 'png'),
        ];
    }
}
