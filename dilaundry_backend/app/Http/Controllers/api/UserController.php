<?php

namespace App\Http\Controllers\api;

use App\Http\Controllers\Controller;
use App\Models\User;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Hash;

class UserController extends Controller
{
    function readAll()
    {
        $users = User::all();

        return response()->json([
            'data' => $users,
        ], 200);
    }

    function register(Request $request)
    {
        $this->validate($request, [
            'username' => 'required|min:4|unique:users',
            'email' => 'required|email|unique:users',
            'password' => 'required|min:8',
        ]);

        $user = User::create([
            'username' => $request->username,
            'email' => $request->email,
            'address' => $request->address,
            'role' => 'User',
            'password' => Hash::make($request->password),
        ]);

        return response()->json([
            'data' => $user,
        ], 201);
    }

    function login(Request $request)
    {
        if (!Auth::attempt($request->only('email', 'password'))) {
            return response()->json([
                'message' => 'Unauthorized'
            ], 401);
        }

        $user = User::where('email', $request->email)->firstOrFail();

        $token = $user->createToken('auth_token')->plainTextToken;

        return response()->json([
            'data' => $user,
            'token' => $token,
        ], 200);
    }

    function editprofil(Request $request)
    {
        $this->validate($request, [
            'username' => 'required|min:4',
            'email' => 'required',
        ]);

        // return response()->json([
        //     'data' => $request->all(),
        //     // 'token' => $token,
        // ], 201);

        $user = User::find(Auth::user()->id);

        if ($request->password) {
            $user->update([
                'username' => $request->username,
                'email' => $request->email,
                'address' => $request->address,
                'password' => Hash::make($request->password)
            ]);
        } else {

            $user->update($request->only('username', 'email', 'address'));
        }

        //  if (!Auth::attempt($request->only('email', 'password'))) {
        //     return response()->json([
        //         'message' => 'Unauthorized'
        //     ], 401);
        // }

        // $user = User::where('email', $request->email)->firstOrFail();

        // $token = $user->createToken('auth_token')->plainTextToken;


        return response()->json([
            'data' => $user,
            // 'token' => $token,
        ], 201);
    }


    function update($id, Request $request)
    {
        $this->validate($request, [
            'username' => 'required|min:4',
            'email' => 'required',
        ]);

        // return response()->json([
        //     'data' => $request->all(),
        //     // 'token' => $token,
        // ], 201);

        $user = User::findOrFail($id);

        if ($request->password) {
            $user->update([
                'username' => $request->username,
                'email' => $request->email,
                'address' => $request->address,
                'password' => Hash::make($request->password),
                'role' => $request->role
            ]);
        } else {

            $user->update($request->only('username', 'email', 'address', 'role'));
        }

        //  if (!Auth::attempt($request->only('email', 'password'))) {
        //     return response()->json([
        //         'message' => 'Unauthorized'
        //     ], 401);
        // }

        // $user = User::where('email', $request->email)->firstOrFail();

        // $token = $user->createToken('auth_token')->plainTextToken;


        return response()->json([
            'data' => $user,
            // 'token' => $token,
        ], 201);
    }

     function create(Request $request)
    {
        $this->validate($request, [
            'username' => 'required|min:4|unique:users',
            'email' => 'required|email|unique:users',
            'password' => 'required|min:8',
        ]);

        $user = User::create([
            'username' => $request->username,
            'email' => $request->email,
            'address' => $request->address,
            'role' => $request->role,
            'password' => Hash::make($request->password),
        ]);

        return response()->json([
            'data' => $user,
        ], 201);
    }

    function delete($id,)
    {

        $shop = User::findOrFail($id);
        // File::delete('storage/shop/' . $shop->image);
        $shop->delete();

        return response()->json([
            'massage' => 'success',
        ], 200);
    }
}
