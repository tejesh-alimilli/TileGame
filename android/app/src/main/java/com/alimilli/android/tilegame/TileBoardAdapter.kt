package com.alimilli.android.tilegame

import android.view.View
import android.view.ViewGroup
import android.content.Context
import android.util.Log
import android.widget.BaseAdapter
import com.alimilli.android.tilegame.dataObjects.TileBoard

class TileBoardAdapter(private val mContext: Context, private val tileBoard: TileBoard): BaseAdapter() {

    override fun getCount(): Int = tileBoard.tiles.size

    override fun getItem(position: Int): Any? = null

    override fun getItemId(position: Int): Long = 0L

    // create a new ImageView for each item referenced by the Adapter
    override fun getView(position: Int, convertView: View?, parent: ViewGroup): View {
        val tileView: TileView

        if (convertView == null) {
            // if it's not recycled, initialize some attributes
            tileView = TileView(mContext)
            val width = parent.width / tileBoard.columnsCount
            if (width != 0) {
                tileView.layoutParams = ViewGroup.LayoutParams(width, width)
            }
        } else {
            tileView = convertView as TileView
        }

        tileView.text = tileBoard.tileAtLinearIndex(position)?.content?.toString() ?: ""

        return tileView
    }
}
