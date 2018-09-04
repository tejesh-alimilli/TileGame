package com.alimilli.android.tilegame

import android.support.v7.app.AppCompatActivity
import android.os.Bundle
import android.util.Log
import android.view.View
import com.alimilli.android.tilegame.dataObjects.TileBoard
import kotlinx.android.synthetic.main.activity_main.*

class MainActivity : AppCompatActivity() {

    private val numberOfCols = 4
    private val numberOfRows = 4
    private val tileBoard = TileBoard(rows = numberOfRows, cols = numberOfCols)
    private val tileBoardAdapter: TileBoardAdapter by lazy {
        TileBoardAdapter(mContext = this, tileBoard = tileBoard)
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_main)

        winningLabel.visibility = View.INVISIBLE

        tilesGridView.numColumns = numberOfCols

        tilesGridView.post {
            // set adapter after layout is done to get proper width and height
            tilesGridView.adapter = tileBoardAdapter
            startNewGame()
        }

        tilesGridView.setOnItemClickListener { parent, view, position, id ->
            if (view !is TileView) {
                return@setOnItemClickListener
            }

            val tilePosition = tileBoard.tilePositionAtLinearIndex(position) ?: return@setOnItemClickListener

            if (!tileBoard.canMoveTile(tilePosition)) {
                return@setOnItemClickListener
            }

            tileBoard.moveTile(tilePosition)

            tileBoardAdapter.notifyDataSetChanged()

            movesValueLabel.text = tileBoard.movesCount.toString()

            if (tileBoard.isComplete()) {
                winningLabel.visibility = View.VISIBLE
            }
        }

        newGameButton.setOnClickListener {
            startNewGame()
        }
    }

    private fun startNewGame() {
        tileBoard.shuffle()
        tileBoardAdapter.notifyDataSetChanged()
        winningLabel.visibility = View.INVISIBLE
        movesValueLabel.text = "0"
    }
}
