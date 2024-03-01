<?php

namespace App\Http\Controllers\api;

use App\Http\Controllers\Controller;
use App\Models\Shop;
use Illuminate\Http\Request;

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

    function create(Request $request){
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

    function update($id, Request $request){
        $input = $request->all();

        $data = Shop::findOrFail($id);

         $$data->update($input);

        return response()->json([
            'data' => $shop,
        ], 201);
    }

    function delete($id){
        $data = Shop::findOrFail($id);

         $data->delete();

        return response()->json([
            'data' => $data,
        ], 200);
    }
}
