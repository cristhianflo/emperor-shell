pragma Singleton
import Quickshell
import Quickshell.Io
import QtQuick
import qs.config

Singleton {
    id: root

    property list<var> workspaces: []
    signal layoutChange

    Socket {
        id: niriSocket
        path: System.niriSocket
        connected: true
        parser: SplitParser {
            onRead: data => {
                try {
                    const res = JSON.parse(data);
                    if (res.Ok && res.Ok.Workspaces) {
                        const arr = res.Ok.Workspaces;
                        root.workspaces = arr.sort((a, b) => a.idx - b.idx);
                    }
                } catch (e) {
                    console.warn("invalid json from socket:", e);
                } finally {
                    niriSocket.flush();
                }
            }
        }

        onConnectionStateChanged: {
            console.log("Connected to Niri socket");
        }
    }

    Socket {
        id: niriEvents
        path: System.niriSocket
        connected: true

        parser: SplitParser {
            id: niriEventsParser
            onRead: data => {
                const res = JSON.parse(data);
                if (res.KeyboardLayoutSwitched) {
                    root.layoutChange();
                }
                root.getWorkspaces();
            }
        }

        onConnectionStateChanged: {
            niriEvents.write('{"EventStream":null}\n');
            niriEvents.flush();
        }
    }

    function getWorkspaces(): void {
        niriSocket.write('{"Workspaces":null}\n');
    }

    function focusWorkspace(index: int): void {
        const req = JSON.stringify({
            Action: {
                FocusWorkspace: {
                    reference: {
                        Index: index
                    }
                }
            }
        });
        niriSocket.write(req + "\n");
    }
}
