<?php

namespace Database\Seeders;

use App\Models\User;
use Illuminate\Database\Console\Seeds\WithoutModelEvents;
use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\Hash;

class UserSeeder extends Seeder
{
    /**
     * Run the database seeds.
     */
    public function run(): void
    {
        $users = [
            [
                'username' => 'admin',
                'email' => 'admin@gmail.com',
                'role' => 'Admin',
                'password' => Hash::make('12345678'),
                'address' => 'Test jl123',
            ],
        ];
        foreach ($users as $userItem) {
            User::create($userItem);
        }
    }
}
