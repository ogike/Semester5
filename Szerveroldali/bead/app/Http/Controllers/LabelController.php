<?php

namespace App\Http\Controllers;

use App\Models\Item;
use App\Models\Label;
use App\Models\User;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Redirect;
use Illuminate\Support\Facades\Session;
use Illuminate\Support\Facades\Auth;

class LabelController extends Controller
{
    /**
     * Display a listing of the resource.
     *
     * @return \Illuminate\Http\Response
     */
    public function index()
    {
        //
    }

    /**
     * Show the form for creating a new resource.
     *
     * @return \Illuminate\Http\Response
     */
    public function create()
    {
        return view('labels.create');
    }

    /**
     * Store a newly created resource in storage.
     *
     * @param  \Illuminate\Http\Request  $request
     * @return \Illuminate\Http\Response
     */
    public function store(Request $request)
    {
        // return Redirect::route('labels.index');

        $validated = $request->validate(
            [
                'name' => [
                    'required',
                    'min:3',
                ],
                'color' => [
                    'required',
                    'regex:/^#([A-Fa-f0-9]{8})$/' //hex validation
                ],
            ],
            [
                'required' => 'This field is required',
                'name.min:3' => 'Labels name must be at least 3 characters long',
                'color' => 'Color value must be a hexadecimal RGB value'
            ]
        );

        if($request->has('display')){
            $validated['display'] = true;
        } else{
            $validated['display'] = false;
        }

        Label::factory()->create($validated);

        Session::flash('label_created', $validated['name']);

        return Redirect::route('labels.create');
    }

    /**
     * Display the specified resource.
     *
     * @param  \App\Models\Label  $label
     * @return \Illuminate\Http\Response
     */
    public function show(Label $label)
    {
        return view('labels.show', [
            // 'items' => $label->items()->get(),
            'items' => $label->items()->paginate(6),
            'items_count' => Item::count(),
            'label' => $label,
            'labels' => Label::all(),
            'user_count' => User::count(),
        ]);
    }

    /**
     * Show the form for editing the specified resource.
     *
     * @param  \App\Models\Label  $label
     * @return \Illuminate\Http\Response
     */
    public function edit(Label $label)
    {
        if(!Auth::check() || !Auth::user()->is_admin){
            Session::flash('unathoriued_label_edit', $label->name);
            return Redirect::route('labels.show', $label);
        }

        return view('labels.edit', $label);
    }

    /**
     * Update the specified resource in storage.
     *
     * @param  \Illuminate\Http\Request  $request
     * @param  \App\Models\Label  $label
     * @return \Illuminate\Http\Response
     */
    public function update(Request $request, Label $label)
    {
        if(!Auth::check() || !Auth::user()->is_admin){
            Session::flash('unathoriued_label_edit', $label->name);
            return Redirect::route('labels.show', $label);
        }

        $validated = $request->validate(
            [
                'name' => [
                    'required',
                    'min:3',
                ],
                'color' => [
                    'required',
                    'regex:/^#([A-Fa-f0-9]{8})$/' //hex validation
                ],
            ],
            [
                'required' => 'This field is required',
                'name.min:3' => 'Labels name must be at least 3 characters long',
                'color.required' => 'Color is required.',
                'color' => 'Color value must be a hexadecimal RGB value'
            ]
        );

        if($request->has('display')){
            $validated['display'] = true;
        } else{
            $validated['display'] = false;
        }

        $label->name = $validated['name'];
        $label->color = $validated['color'];
        $label->display = $validated['display'];
        $label->save();

        if (isset($validated['posts'])){
            $label->items()->sync($validated['categories']);
        }

        Session::flash('label_updated', $validated['name']);

        return Redirect::route('labels.show', $label);

    }

    /**
     * Remove the specified resource from storage.
     *
     * @param  \App\Models\Label  $label
     * @return \Illuminate\Http\Response
     */
    public function destroy(Label $label)
    {
        //
    }
}
