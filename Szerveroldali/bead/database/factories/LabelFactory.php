<?php

namespace Database\Factories;

use Illuminate\Database\Eloquent\Factories\Factory;

/**
 * @extends \Illuminate\Database\Eloquent\Factories\Factory<\App\Models\Label>
 */
class LabelFactory extends Factory
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
            "name" => fake()->word(),
            // $table->boolean('display');
            'display' => true,
            'color' => fake()->safeHexColor() . "ff",
        ];
    }
}
