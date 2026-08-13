// SPDX-License-Identifier: GPL-2.0-only
/*
 * Tablica Znakowa - Kontroler
 *
 * Copyright (C) 2026 ŻupaNET Development <devel@zupanet.pl>
 */

import QtQuick

Item {
    id: root

    property real threshold: 100

    signal swipedLeft()
    signal swipedRight()

    DragHandler {
        id: drag

        target: null

        xAxis.enabled: true
        yAxis.enabled: false

        property real startX: 0

        onActiveChanged: {
            if(active)
            {
                startX = centroid.position.x
                return
            }

            const delta = centroid.position.x - startX

            if(Math.abs(delta) < root.threshold)
                return

            if(delta < 0)
                root.swipedLeft()
            else
                root.swipedRight()
        }
    }
}
