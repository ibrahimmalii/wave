<?php

namespace Database\Factories;

use Illuminate\Database\Eloquent\Factories\Factory;

class ServiceFactory extends Factory
{
    /**
     * Define the model's default state.
     *
     * @return array
     */
    public function definition()
    {
        return [
            'title' => $this->faker->text(),
            'title_subtitle' => $this->faker->text(),
            'description' => $this->faker->text(),
            'description_subtitle' => $this->faker->text(),
            'small_price' => 200,
            'mid_price' => 300,
            'large_price' => 400,
            'discount' => 0,
            'service_type_id' => $this->faker->numberBetween(1,2)
        ];
    }
}
