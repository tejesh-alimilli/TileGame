package com.alimilli.android.tilegame

import android.content.Context
import android.view.LayoutInflater
import android.widget.LinearLayout
import kotlinx.android.synthetic.main.tile_view_layout.view.*

class TileView(private val mContext: Context): LinearLayout(mContext) {
    var text: String
        get() = textView.text.toString()
        set(value) {
            textView.text = value
        }

    init {
        val inflater = LayoutInflater.from(mContext)
        val view = inflater.inflate(R.layout.tile_view_layout, this, false)
        addView(view)
    }
}
