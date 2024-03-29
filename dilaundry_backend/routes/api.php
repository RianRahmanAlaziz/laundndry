<?php

use App\Http\Controllers\api\LaundryController;
use App\Http\Controllers\api\PromoController;
use App\Http\Controllers\api\ShopController;
use App\Http\Controllers\api\UserController;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;

/*
|--------------------------------------------------------------------------
| API Routes
|--------------------------------------------------------------------------
|
| Here is where you can register API routes for your application. These
| routes are loaded by the RouteServiceProvider and all of them will
| be assigned to the "api" middleware group. Make something great!
|
*/

// Route::middleware('auth:sanctum')->get('/user', function (Request $request) {
//     return $request->user();
// });

Route::get('/promo', [PromoController::class, 'readAll']);
Route::get('/shop', [ShopController::class, 'readAll']);
// Route::get('/laundry', [LaundryController::class, 'readAll']);
Route::get('/user', [UserController::class, 'readAll']);

Route::post('/register', [UserController::class, 'register']);
Route::post('/login', [UserController::class, 'login']);

Route::post('/shop/{id}', [ShopController::class, 'update']);


Route::middleware('auth:sanctum')->group(function () {
    Route::get('/users', [UserController::class, 'readAll']);
    Route::post('/users', [UserController::class, 'create']);
    Route::post('/users/{id}', [UserController::class, 'update']);
    Route::delete('/users/{id}', [UserController::class, 'delete']);

    Route::post('/user/edit', [UserController::class, 'editprofil']);
    Route::get('/laundry', [LaundryController::class, 'readAll']);
    Route::post('/laundry', [LaundryController::class, 'create']);
    // Laundry
    Route::get('/laundry/user/{id}', [LaundryController::class, 'whereUserId']);
    Route::post('/laundry/claim', [LaundryController::class, 'claim']);
    Route::get('/laundry/{id}/{status}', [LaundryController::class, 'updateStatus']);

    // Promo
    Route::get('/promo/limit', [PromoController::class, 'readLimit']);

    // Shop
    Route::get('/shop/recommendation/limit', [ShopController::class, 'readRecommendationLimit']);
    Route::get('/shop/search/city/{name}', [ShopController::class, 'searchByCity']);
    Route::post('/shop', [ShopController::class, 'create']);

    Route::delete('/shop/{id}', [ShopController::class, 'delete']);
});
