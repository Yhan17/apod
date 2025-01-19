package com.example.apod

import android.appwidget.AppWidgetManager
import android.appwidget.AppWidgetProvider
import android.content.Context
import android.graphics.BitmapFactory
import android.net.Uri
import android.util.Log
import android.widget.RemoteViews
import es.antonborri.home_widget.HomeWidgetPlugin
import androidx.core.content.FileProvider
import java.io.File

class ApodWidget : AppWidgetProvider() {

    override fun onUpdate(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetIds: IntArray
    ) {
        for (appWidgetId in appWidgetIds) {
            val widgetData = HomeWidgetPlugin.getData(context)

            val imagePath = widgetData.getString("apodImageRendered", null)

            val views = RemoteViews(context.packageName, R.layout.apod_widget).apply {
                if (!imagePath.isNullOrEmpty()) {
                    val imageFile = File(imagePath)
                    if (imageFile.exists()) {
                        val myBitmap = BitmapFactory.decodeFile(imageFile.absolutePath)
                        setImageViewBitmap(R.id.homeWidgetBackground, myBitmap)
                    } else {
                        // Arquivo não encontrado
                        Log.d("ApodImage","Image not found at: $imagePath")
                    }
                } else {
                    // Nenhum caminho salvo
                    Log.d("ApodImage","No image path found in SharedPreferences for key 'lineChart'")
                }
            }

            // 4) Atualiza o widget na tela
            appWidgetManager.updateAppWidget(appWidgetId, views)
        }
    }


    override fun onEnabled(context: Context) {
        Log.d("ApodWidget", "Widget enabled")
    }

    override fun onDisabled(context: Context) {
        Log.d("ApodWidget", "Widget disabled")
    }
}
