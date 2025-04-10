<script lang="ts">
    import { fly } from "svelte/transition";
    import { writable } from "svelte/store";
    import { enableUserInputsStore } from "../Stores/UserInputStore";
    import { mapEditorModeStore } from "../Stores/MapEditorStore";
    import { chatVisibilityStore, INITIAL_SIDEBAR_WIDTH } from "../Stores/ChatStore";
    import { gameManager } from "../Phaser/Game/GameManager";
    import Chat from "./Components/Chat.svelte";
    import { IconX } from "@wa-icons";

    export const chatSidebarWidthStore = writable(INITIAL_SIDEBAR_WIDTH);
    let container: HTMLElement;

    const gameScene = gameManager.getCurrentGameScene();

    function reposition() {
        gameScene.reposition();
    }

    function closeChat() {
        chatVisibilityStore.set(false);
    }

    function onKeyDown(e: KeyboardEvent) {
        if (e.key === "Escape" && $chatVisibilityStore) {
            closeChat();
        } else if (e.key === "c" && !$chatVisibilityStore && !$mapEditorModeStore && $enableUserInputsStore) {
            chatVisibilityStore.set(true);
        }
    }

    let sideBarWidth: number = $chatSidebarWidthStore;

    const handleMousedown = (e: MouseEvent) => {
        let dragX = e.clientX;
        document.onmousemove = (e) => {
            const vw = Math.max(document.documentElement.clientWidth, window.innerWidth || 0);
            const newWidth = Math.min(container.offsetWidth + e.clientX - dragX, vw);
            container.style.maxWidth = newWidth + "px";
            container.style.width = newWidth + "px";
            dragX = e.clientX;
        };
        document.onmouseup = () => {
            document.onmousemove = null;
            chatSidebarWidthStore.set(sideBarWidth);
            reposition();
        };
    };

    const handleTouchStart = (e: TouchEvent) => {
        let dragX = e.targetTouches[0].pageX;

        function onTouchMove(e: TouchEvent) {
            const vw = Math.max(document.documentElement.clientWidth, window.innerWidth || 0);
            const newWidth = Math.min(container.offsetWidth + e.targetTouches[0].pageX - dragX, vw);

            container.style.maxWidth = newWidth + "px";
            container.style.width = newWidth + "px";
            dragX = e.targetTouches[0].pageX;
        }

        document.addEventListener("touchmove", onTouchMove);

        document.addEventListener("touchend", () => {
            document.removeEventListener("touchmove", onTouchMove);
            chatSidebarWidthStore.set(sideBarWidth);
            reposition();
        });
    };

    const handleDbClick = () => {
        if (isChatBarInFullScreen()) {
            container.style.maxWidth = INITIAL_SIDEBAR_WIDTH + "px";
            container.style.width = INITIAL_SIDEBAR_WIDTH + "px";
        } else {
            container.style.maxWidth = document.documentElement.clientWidth + "px";
            container.style.width = document.documentElement.clientWidth + "px";
        }
        chatSidebarWidthStore.set(sideBarWidth);
    };

    const onresize = () => {
        if (isChatSidebarLargerThanWindow()) {
            container.style.maxWidth = document.documentElement.clientWidth + "px";
            container.style.width = document.documentElement.clientWidth + "px";
            chatSidebarWidthStore.set(sideBarWidth);
        }
    };

    const isChatSidebarLargerThanWindow = () => {
        return sideBarWidth >= document.documentElement.clientWidth;
    };

    const isChatBarInFullScreen = () => {
        return sideBarWidth === document.documentElement.clientWidth;
    };
</script>

<svelte:window on:keydown={onKeyDown} on:resize={onresize} />
{#if $chatVisibilityStore}
    <section
        bind:clientWidth={sideBarWidth}
        bind:this={container}
        id="chat"
        data-testid="chat"
        transition:fly={{ duration: 200, x: -sideBarWidth }}
        on:introend={reposition}
        on:outroend={reposition}
        style="width: {sideBarWidth}px; max-width: {Math.min(sideBarWidth, document.documentElement.clientWidth)}px;"
        class="chatWindow !tw-min-w-full sm:!tw-min-w-[360px] tw-bg-contrast/80 tw-backdrop-blur-md tw-p-0 screen-blocker"
    >
        <div class="close-window tw-absolute -tw-right-[4.5rem] tw-top-2 tw-p-2 tw-bg-contrast/80 tw-rounded-2xl">
            <button
                class="tw-p-3 hover:tw-bg-white/10 tw-rounded-xl tw-aspect-square tw-w-12 tw-m-0"
                data-testid="closeChatButton"
                on:click={closeChat}
            >
                <IconX font-size="20" />
            </button>
        </div>
        <Chat {sideBarWidth} />

        <div
            class="!tw-absolute !tw-right-1 !tw-top-0 !tw-bottom-0 !tw-m-auto !tw-w-1 !tw-h-32 !tw-bg-white !tw-rounded !tw-cursor-col-resize"
            id="resize-bar"
            on:mousedown={handleMousedown}
            on:dblclick={handleDbClick}
            on:touchstart={handleTouchStart}
        />
    </section>
{/if}

<style lang="scss">
    @import "../style/breakpoints.scss";

    @include media-breakpoint-up(sm) {
        .chatWindow {
            width: 100% !important;
        }
    }

    .chatWindow {
        color: white;
        position: absolute !important;
        top: 0;
        min-width: 335px !important;
        width: 335px;
        pointer-events: auto;
        max-width: calc(100vw - 82px) !important;
        height: 100dvh !important;
        z-index: 2000;
        .close-window {
            cursor: pointer;
            align-self: end;
        }
    }
</style>
