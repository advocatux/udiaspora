import QtQuick 2.4
import QtQuick.Layouts 1.1
import Ubuntu.Components 1.3

Page {
    id: instancePickerPage
    anchors.fill: parent
    Component.onCompleted: getSample ()

    /* Load list of Mastodon Instances from https://instances.social
    * The Response is in format:
    * { id, name, added_at, updated_at, checked_at, uptime, up, dead, version,
    * ipv6, https_score, https_rank, obs_score, obs_rank, users, statuses,
    * connections, open_registrations, info { short_description, full_description,
    *      topic, languages[], other_languages_accepted, federates_with,
    *      prhobited_content[], categories[]}, thumbnail, active_users }
    */
    function getSample () {

        var http = new XMLHttpRequest();
        var data = "?" +
        "format=json&" +
        "key="+token+"&";

        http.open("GET", "https://podupti.me/api.php?&key=4r45tg" + data, true);
        http.setRequestHeader('Content-type', 'application/json; charset=utf-8')
        http.onreadystatechange = function() {
            if (http.readyState === XMLHttpRequest.DONE) {
                var response = JSON.parse(http.responseText)
                instanceList.writeInList ( response.pod )
            }
        }
        http.send();
    }


    function search () 
		getSample();
		//do the filtering
    }



    header: PageHeader {
        id: header
        title: i18n.tr('Choose a Disapora instance')
        StyleHints {
            foregroundColor: theme.palette.normal.backgroundText
            backgroundColor: theme.palette.normal.background
        }
        trailingActionBar {
            actions: [
            Action {
                text: i18n.tr("Info")
                iconName: "info"
                onTriggered: {
                    mainStack.push(Qt.resolvedUrl("./Info.qml"))
                }
            },
            Action {
                iconName: "search"
                onTriggered: {
                    if ( customInstanceInput.displayText == "" ) {
                        customInstanceInput.focus = true
                    }
                    else search ()
                }
            }
            ]
        }
    }

    ActivityIndicator {
        id: loading
        visible: true
        running: true
        anchors.centerIn: parent
    }


    TextField {
		enable:false
        id: customInstanceInput
        anchors.top: header.bottom
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.topMargin: height
        width: parent.width - height
        placeholderText: i18n.tr("Search or enter a custom address")
        Keys.onReturnPressed: search ()
    }

    ScrollView {
        id: scrollView
        width: parent.width
        height: parent.height - header.height - 3*customInstanceInput.height
        anchors.top: customInstanceInput.bottom
        anchors.topMargin: customInstanceInput.height
        contentItem: Column {
            id: instanceList
            width: root.width

            // Write a list of instances to the ListView
            function writeInList ( list ) {
                instanceList.children = ""
                loading.visible = false
                for ( var i = 0; i < list.length; i++ ) {
                    var item = Qt.createComponent("../components/InstanceItem.qml")
                    item.createObject(this, {
                        "text": list[i].domain,
                        "description": list[i].country != null ? list[i].country : "",
                        "long_description": list[i].uptimelast7 != null ? list[i].uptimelast7 : "",
                        "iconSource":  list[i].thumbnail != null ? list[i].thumbnail : "../../assets/logo.svg"
                    })
                }
            }
        }
    }

}