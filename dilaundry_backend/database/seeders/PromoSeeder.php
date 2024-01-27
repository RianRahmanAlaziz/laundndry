<?php

namespace Database\Seeders;

use App\Models\Promo;
use Illuminate\Database\Console\Seeds\WithoutModelEvents;
use Illuminate\Database\Seeder;

class PromoSeeder extends Seeder
{
    /**
     * Run the database seeds.
     */
    public function run(): void
    {
        $promos = [
            [
                'image' => 'luxurygrey.jpg',
                'shop_id' => 5,
                'old_price' => 17000,
                'new_price' => 10000,
                'description' => 'Promo Awal Tahun',
            ],
            [
                'image' => 'undercoverset.jpg',
                'shop_id' => 9,
                'old_price' => 14500,
                'new_price' => 8000,
                'description' => 'Promo Awal Tahun',
            ],
        ];

        foreach ($promos as $promoItem) {
            Promo::create($promoItem);
        }
    }
}
