<?php

namespace App\Http\Controllers\api;

use App\Http\Controllers\Controller;
use App\Models\Laundry;
use Illuminate\Http\Request;
use Illuminate\Support\Str;

class LaundryController extends Controller
{
    function readAll()
    {
        $laundries = Laundry::with('user', 'shop')->get();

        return response()->json([
            'data' => $laundries,
        ], 200);
    }

    function whereUserId($id)
    {
        $laundries = Laundry::where('user_id', '=', $id)
            ->with('shop', 'user')
            ->orderBy('created_at', 'desc')
            ->get();

        if (count($laundries) > 0) {
            return response()->json([
                'data' => $laundries,
            ], 200);
        } else {
            return response()->json([
                'message' => 'not found',
                'data' => $laundries,
            ], 404);
        }
    }

    function create(Request $request)
    {
        $input = $request->all();

        // return response()->json([
        //     'data' => $input["total"],
        // ],200);

        $input['claim_code'] = Str::upper(Str::random(10));
        $input['with_pickup'] = true;
        $input['with_delivery'] = true;
        $input['status'] = 'New';
        $user = Laundry::create($input);

        return response()->json([
            'data' => $user,
        ], 201);
    }

    function updateStatus($id, $status)
    {
        $data = Laundry::findOrFail($id);

        $data->update(['status' => $status]);

        return response()->json([
            'data' => $data,
        ], 201);
    }

    function claim(Request $request)
    {
        $laundry = Laundry::where([
            ['id', '=', $request->id],
            ['claim_code', '=', $request->claim_code],
        ])->first();

        if (!$laundry) {
            return response()->json([
                'message' => 'not found',
            ], 404);
        }

        if ($laundry->user_id != 0) {
            return response()->json([
                'message' => 'Laundry has been claimed',
            ], 400);
        }

        $laundry->user_id = $request->user_id;
        $updated = $laundry->save();

        if ($updated) {
            return response()->json([
                'data' => $updated,
            ], 201);
        } else {
            return response()->json([
                'message' => 'can not be updated'
            ], 500);
        }
    }
}
