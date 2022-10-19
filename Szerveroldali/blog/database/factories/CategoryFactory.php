<?php

namespace Database\Factories;

use Illuminate\Database\Eloquent\Factories\Factory;

/**
 * @extends \Illuminate\Database\Eloquent\Factories\Factory<\App\Models\Category>
 */
class CategoryFactory extends Factory
{
    /**
     * Define the model's default state.
     *
     * @return array<string, mixed>
     */
    public function definition()
    {
        return [
            'name' => fake()->name(),
            // 'text_color' => fake()->safeHexColor() . "ff", // '.' operator: string concatenation
            // 'background_color' => fake()->safeHexColor() . "ff",
            'style' => fake()->randomElement(['primary', 'secondary','danger', 'warning', 'info', 'dark']),
        ];
    }
}
