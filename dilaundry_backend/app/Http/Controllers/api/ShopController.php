<?php

namespace App\Http\Controllers\api;

use App\Http\Controllers\Controller;
use App\Models\Shop;
use Illuminate\Http\Request;
use Illuminate\Validation\ValidationException;

class ShopController extends Controller
{
    function readAll()
    {
        $shops = Shop::orderBy('created_at', 'desc')->get();

        return response()->json([
            'data' => $shops,
        ], 200);
    }

    function readRecommendationLimit()
    {
        $shops = Shop::orderBy('rate', 'desc')
            ->limit(5)
            ->get();

        if (count($shops) > 0) {
            return response()->json([
                'data' => $shops,
            ], 200);
        } else {
            return response()->json([
                'message' => 'not found',
                'data' => $shops,
            ], 404);
        }
    }

    function searchByCity($name)
    {
        $shops = Shop::where('city', 'like', '%' . $name . '%')
            ->orderBy('name')
            ->get();

        if (count($shops) > 0) {
            return response()->json([
                'data' => $shops,
            ], 200);
        } else {
            return response()->json([
                'message' => 'not found',
                'data' => $shops,
            ], 404);
        }
    }

    function create(Request $request)
    {
        $input = $request->all();

        // return response()->json([
        //     'data' => $input,
        // ],200);

        $input['delivery'] = 1;
        $input['pickup'] = 1;
        $input['rate'] = 0;
    

        $shop = Shop::create($input);

        return response()->json([
            'data' => $shop,
        ], 201);
    }

    function update($id, Request $request, Shop $shop)
    {
        try {

            $input = $request->all();

            $shop = Shop::findOrFail($id);

            $shop->update($input);

            return response()->json([
                'data' => $shop,
            ], 200);
        } catch (ValidationException $e) {
            return response()->json([
                'error' => $e->errors(),
            ], 422);
        } catch (\Exception $e) {
            return response()->json([
                'error' => 'Gagal memperbarui data.',
            ], 500);
        }

        // $data = Shop::findOrFail($id);

        // $data->update($input);

        // return response()->json([
        //     'data' => $data,
        // ], 201);
    }

    function delete($id)
    {
        $shop = Shop::findOrFail($id);

        $shop->delete();

        return response()->json([
            'massage' => 'success',
        ], 200);
    }

    function delete($id){
        $data = Shop::findOrFail($id);

         $data->delete();

        return response()->json([
            'data' => $data,
        ], 200);
    }
}
