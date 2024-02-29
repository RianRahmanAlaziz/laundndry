<?php

namespace Database\Seeders;

use App\Models\Shop;
use Illuminate\Database\Console\Seeds\WithoutModelEvents;
use Illuminate\Database\Seeder;

class ShopSeeder extends Seeder
{
    /**
     * Run the database seeds.
     */
    public function run(): void
    {
        $shops = [
            [
                'image' => 'aquoshseed.jpg',
                'name' => 'Aquosh Seed',
                'location' => 'Jl. Otto tomato No. 1',
                'city' => 'Garut',
                'delivery' => 0,
                'pickup' => 0,
                'whatsapp' => '620812345681',
                'category' => 'Regular, Express',
                'description' => 'Laundry refers to the washing of clothing and other textiles, and, more broadly, their drying and ironing as well. Laundry has been part of history since humans began to wear clothes, so the methods by which different cultures have dealt with this universal human need are of interest to several branches of scholarship.',
                'price_cuci_komplit' => 17000,
                'price_dry_clean' => 0,
                'price_cuci_satuan' => 0,
                'rate' => 4.1,
            ],
            [
                'image' => 'bluewhitelock.jpg',
                'name' => 'Blue White Lock',
                'location' => 'Jl. Sumbawa no 40',
                'city' => 'Bandung',
                'delivery' => 0,
                'pickup' => 1,
                'whatsapp' => '620812345672',
                'category' => 'Economical, Express',
                'description' => 'Laundry refers to the washing of clothing and other textiles, and, more broadly, their drying and ironing as well. Laundry has been part of history since humans began to wear clothes, so the methods by which different cultures have dealt with this universal human need are of interest to several branches of scholarship.',
                'price_cuci_komplit' => 23000,
                'price_dry_clean' => 0,
                'price_cuci_satuan' => 0,
                'rate' => 4.3,
            ],
            [
                'image' => 'clingset.jpg',
                'name' => 'Cling Set',
                'location' => 'Jl. Papasakan No. 3',
                'city' => 'Garut',
                'delivery' => 0,
                'pickup' => 0,
                'whatsapp' => '620812345679',
                'category' => 'Express',
                'description' => 'Laundry refers to the washing of clothing and other textiles, and, more broadly, their drying and ironing as well. Laundry has been part of history since humans began to wear clothes, so the methods by which different cultures have dealt with this universal human need are of interest to several branches of scholarship.',
                'price_cuci_komplit' => 15000,
                'price_dry_clean' => 0,
                'price_cuci_satuan' => 0,
                'rate' => 4.2,
            ],
            [
                'image' => 'escapedlaundry.jpg',
                'name' => 'Escape D Laundry',
                'location' => 'Jl. Situhapa No. 34',
                'city' => 'Jakarta',
                'delivery' => 1,
                'pickup' => 1,
                'whatsapp' => '620812345678',
                'category' => 'Express',
                'description' => 'Laundry refers to the washing of clothing and other textiles, and, more broadly, their drying and ironing as well. Laundry has been part of history since humans began to wear clothes, so the methods by which different cultures have dealt with this universal human need are of interest to several branches of scholarship.',
                'price_cuci_komplit' => 31000,
                'price_dry_clean' => 0,
                'price_cuci_satuan' => 0,
                'rate' => 4.9,
            ],
            [
                'image' => 'luxurygrey.jpg',
                'name' => 'Luxury Grey',
                'location' => 'Jl. Suniaraja No. 51',
                'city' => 'Jakarta',
                'delivery' => 0,
                'pickup' => 0,
                'whatsapp' => '620812345673',
                'category' => 'Exlusive',
                'description' => 'Laundry refers to the washing of clothing and other textiles, and, more broadly, their drying and ironing as well. Laundry has been part of history since humans began to wear clothes, so the methods by which different cultures have dealt with this universal human need are of interest to several branches of scholarship.',
                'price_cuci_komplit' => 16000,
                'price_dry_clean' => 0,
                'price_cuci_satuan' => 0,
                'rate' => 4.0,
            ],
            [
                'image' => 'macleanjet.jpeg',
                'name' => 'Maclean Jet',
                'location' => 'Urug lost way street No. 23',
                'city' => 'Garut',
                'delivery' => 1,
                'pickup' => 1,
                'whatsapp' => '620812345678',
                'category' => 'Regular, Express',
                'description' => 'Laundry refers to the washing of clothing and other textiles, and, more broadly, their drying and ironing as well. Laundry has been part of history since humans began to wear clothes, so the methods by which different cultures have dealt with this universal human need are of interest to several branches of scholarship.',
                'price_cuci_komplit' => 20000,
                'price_dry_clean' => 0,
                'price_cuci_satuan' => 0,
                'rate' => 4.5,
            ],
            [
                'image' => 'rubberwil.jpg',
                'name' => 'Rubber Wil',
                'location' => 'Jl. Sucinaraja No. 1',
                'city' => 'Surabaya',
                'delivery' => 1,
                'pickup' => 1,
                'whatsapp' => '620812345674',
                'category' => 'Regular',
                'description' => 'Laundry refers to the washing of clothing and other textiles, and, more broadly, their drying and ironing as well. Laundry has been part of history since humans began to wear clothes, so the methods by which different cultures have dealt with this universal human need are of interest to several branches of scholarship.',
                'price_cuci_komplit' => 19000,
                'price_dry_clean' => 0,
                'price_cuci_satuan' => 0,
                'rate' => 4.1,
            ],
            [
                'image' => 'streetbrush.jpg',
                'name' => 'Street Brush',
                'location' => 'Jl. kebon Jati No. 3',
                'city' => 'Bandung',
                'delivery' => 0,
                'pickup' => 0,
                'whatsapp' => '620812345677',
                'category' => 'Regular',
                'description' => 'Laundry refers to the washing of clothing and other textiles, and, more broadly, their drying and ironing as well. Laundry has been part of history since humans began to wear clothes, so the methods by which different cultures have dealt with this universal human need are of interest to several branches of scholarship.',
                'price_cuci_komplit' => 21000,
                'price_dry_clean' => 0,
                'price_cuci_satuan' => 0,
                'rate' => 4.2,
            ],
            [
                'image' => 'undercoverset.jpg',
                'name' => 'Undercover Set',
                'location' => 'Jl. kebon Jati No. 3',
                'city' => 'Bandung',
                'delivery' => 0,
                'pickup' => 0,
                'whatsapp' => '620812345675',
                'category' => 'Regular, Express',
                'description' => 'Laundry refers to the washing of clothing and other textiles, and, more broadly, their drying and ironing as well. Laundry has been part of history since humans began to wear clothes, so the methods by which different cultures have dealt with this universal human need are of interest to several branches of scholarship.',
                'price_cuci_komplit' => 20000,
                'price_dry_clean' => 0,
                'price_cuci_satuan' => 0,
                'rate' => 4.2,
            ],
            [
                'image' => 'whiteroom.jpg',
                'name' => 'White Room',
                'location' => 'Jl. Cicendo No. 1',
                'city' => 'Bandung',
                'delivery' => 1,
                'pickup' => 1,
                'whatsapp' => '620812345676',
                'category' => 'Regular, Economical',
                'description' => 'Laundry refers to the washing of clothing and other textiles, and, more broadly, their drying and ironing as well. Laundry has been part of history since humans began to wear clothes, so the methods by which different cultures have dealt with this universal human need are of interest to several branches of scholarship.',
                'price_cuci_komplit' => 22000,
                'price_dry_clean' => 0,
                'price_cuci_satuan' => 0,
                'rate' => 4.4,
            ],

        ];

        foreach ($shops as $shopItem) {
            Shop::create($shopItem);
        }
    }
}
