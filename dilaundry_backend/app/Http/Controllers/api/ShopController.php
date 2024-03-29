<?php

namespace App\Http\Controllers\api;

use App\Http\Controllers\Controller;
use App\Models\Shop;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\File;
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

        if ($request->has('image')) {
            $gambar = $request->file('image');
            $nama_gambar = time() . rand(1, 9) . '.' . $gambar->getClientOriginalExtension();
            $gambar->move('storage/shop', $nama_gambar);
            $input['image'] = $nama_gambar;
        }

        // if ($request->file('image')) {
        //     $nama_gambar = time() . rand(1, 9) . '.' . $request->file('image')->getClientOriginalExtension();
        //     $input['image'] = $request->file('image')->store('shop', $nama_gambar);
        // }

        $input['delivery'] = 1;
        $input['pickup'] = 1;
        $input['rate'] = 0;

        $input['price_cuci_komplit'] = doubleval($request['price_cuci_komplit']);
        $input['price_dry_clean'] = doubleval($request['price_dry_clean']);
        $input['price_cuci_satuan'] = doubleval($request['price_cuci_satuan']);



        $shop = Shop::create($input);

        return response()->json([
            'data' => $shop,
        ], 201);
    }

    function update($id, Request $request)
    {
        $input = $request->all();

        $shop = Shop::findOrFail($id);
        if ($request->has('image')) {
            File::delete('storage/shop' . $shop->image);

            $gambar = $request->file('image');
            $nama_gambar = time() . rand(1, 9) . '.' . $gambar->getClientOriginalExtension();
            $gambar->move('storage/shop', $nama_gambar);
            $input['image'] = $nama_gambar;
        } else {
            unset($input['image']);
        }

        $input['delivery'] = 1;
        $input['pickup'] = 1;
        $input['rate'] = 0;

        $input['price_cuci_komplit'] = doubleval($request['price_cuci_komplit']);
        $input['price_dry_clean'] = doubleval($request['price_dry_clean']);
        $input['price_cuci_satuan'] = doubleval($request['price_cuci_satuan']);



        $shop->update($input);

        return response()->json([
            'data' => $shop,
        ], 200);
    }

    function delete($id,)
    {

        $shop = Shop::findOrFail($id);
        File::delete('storage/shop/' . $shop->image);
        $shop->delete();

        return response()->json([
            'massage' => 'success',
        ], 200);
    }
}
