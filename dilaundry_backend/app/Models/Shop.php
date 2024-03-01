<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Shop extends Model
{
    use HasFactory;

    public function laundries()
    {
        return $this->hasMany(Laundry::class);
    }

    public function promo()
    {
        return $this->hasMany(Promo::class);
    }
    protected $fillable = [
        'image',
        'name',
        'location',
        'city',
        'delivery',
        'pickup',
        'whatsapp',
        'category',
        'description',
        'price_cuci_komlpit',
        'price_dry_clean',
        'price_cuci_satuan',
        'rate',
    ];

    public $appends = ['categories'];

    public function getCategoriesAttribute()
    {
        return explode(', ', $this->category);
    }
}
