<script lang="ts">
    import { fly } from "svelte/transition";
    import { AvailabilityStatus } from "@workadventure/messages";
    import { resetAllStatusStoreExcept } from "../../../Rules/StatusRules/statusChangerFunctions";
    import { availabilityStatusMenuStore } from "../../../Stores/AvailabilityStatusMenuStore";
    import { RequestedStatus } from "../../../Rules/StatusRules/statusRules";
    import { externalAvailibilitySatusSvelteComponent } from "../../../Stores/Utils/externalSvelteComponentStore";
    import AvailabilityStatusCircle from "./AvailabilityStatusCircle.svelte";
    import { AvailabilityStatusListPropsInterface } from "./Interfaces/AvailabilityStatusPropsInterface";

    export let props: AvailabilityStatusListPropsInterface;

    $: ({ listStatusTitle, statusInformation, currentStatus } = props);

    const handleKeyPress = (e: KeyboardEvent, newStatus: RequestedStatus | AvailabilityStatus.ONLINE | null) => {
        if (newStatus === AvailabilityStatus.ONLINE) newStatus = null;
        if (e.key === "Enter") {
            resetAllStatusStoreExcept(newStatus);
            availabilityStatusMenuStore.closeAvailabilityStatusMenu();
        }
    };
    const handleClick = (newStatus: RequestedStatus | AvailabilityStatus.ONLINE | null) => {
        if (newStatus === AvailabilityStatus.ONLINE) newStatus = null;
        resetAllStatusStoreExcept(newStatus);
        availabilityStatusMenuStore.closeAvailabilityStatusMenu();
    };
    const handleOutsideClick = () => {
        if ($availabilityStatusMenuStore) availabilityStatusMenuStore.closeAvailabilityStatusMenu();
    };
</script>

<svelte:window on:click={handleOutsideClick} on:touchend={handleOutsideClick} />

<div
    class="tw-absolute tw-mt-2 tw-bottom-24 tw-mx-auto sm:tw-bottom-16 tw-bottom-2' tw-bg-dark-purple/75 tw-backdrop-blur tw-rounded-lg tw-py-2 tw-w-48 tw-text-white
            before:tw-content-[''] before:tw-absolute before:tw-w-0 before:tw-h-0 before:tw--bottom-[14px] before:tw-left-8
            before:tw-border-solid before:tw-border-8 before:tw-border-transparent
            before:tw-border-b-contrast/80 tw-transition-all before:tw-rotate-180"
    transition:fly={{ y: 40, duration: 150 }}
>
    {#if $externalAvailibilitySatusSvelteComponent.size > 0}
        {#each [...$externalAvailibilitySatusSvelteComponent.entries()] as [key, value] (`${key}`)}
            <svelte:component this={value.componentType} extensionModule={value.extensionModule} />
        {/each}
    {/if}
    <div class="tw-flex tw-flex-row tw-justify-between tw-text-xs tw-p-2 tw-pb-0">
        <div class="tw-font-bold tw-opacity-80">{listStatusTitle.toUpperCase()}</div>
        <svg width="18px" height="18px" viewBox="0 0 24.00 24.00" fill="none" xmlns="http://www.w3.org/2000/svg"
            ><g id="SVGRepo_bgCarrier" stroke-width="0" /><g
                id="SVGRepo_tracerCarrier"
                stroke-linecap="round"
                stroke-linejoin="round"
            /><g id="SVGRepo_iconCarrier">
                <path
                    d="M12 16V12M12 8H12.01M7.8 21H16.2C17.8802 21 18.7202 21 19.362 20.673C19.9265 20.3854 20.3854 19.9265 20.673 19.362C21 18.7202 21 17.8802 21 16.2V7.8C21 6.11984 21 5.27976 20.673 4.63803C20.3854 4.07354 19.9265 3.6146 19.362 3.32698C18.7202 3 17.8802 3 16.2 3H7.8C6.11984 3 5.27976 3 4.63803 3.32698C4.07354 3.6146 3.6146 4.07354 3.32698 4.63803C3 5.27976 3 6.11984 3 7.8V16.2C3 17.8802 3 18.7202 3.32698 19.362C3.6146 19.9265 4.07354 20.3854 4.63803 20.673C5.27976 21 6.11984 21 7.8 21Z"
                    stroke="#929292"
                    stroke-width="2.4"
                    stroke-linecap="round"
                    stroke-linejoin="round"
                />
            </g></svg
        >
    </div>
    {#each statusInformation as statusInformationValue (statusInformationValue.AvailabilityStatus)}
        <div
            class="changeStatusButton tw-px-5 tw-py-10px tw-h-full tw-m-0 tw-cursor-pointer tw-list-none hover:tw-bg-dark-purple/80"
            on:keyup={(e) => {
                handleKeyPress(e, statusInformationValue.AvailabilityStatus);
            }}
            on:click|stopPropagation={() => handleClick(statusInformationValue.AvailabilityStatus)}
        >
            <div class="tw-flex tw-justify-start tw-my-1 tw-py-1.5 tw-cursor-pointer">
                <AvailabilityStatusCircle
                    cursorType="pointer"
                    position="relative"
                    colorHex={statusInformationValue.colorHex}
                />
                <div
                    class="tw-px-4 tw-cursor-pointer {currentStatus !== statusInformationValue.AvailabilityStatus
                        ? ''
                        : 'tw-opacity-50'}"
                >
                    {statusInformationValue.label}
                </div>
                {#if currentStatus === statusInformationValue.AvailabilityStatus}
                    <div>
                        <svg class="tw-cursor-pointer" width="24" height="24" viewBox="0 0 24 24" fill="none">
                            <path
                                d="M10.5858 13.4142L7.75735 10.5858L6.34314 12L10.5858 16.2427L17.6568 9.1716L16.2426 7.75739L10.5858 13.4142Z"
                                xmlns="http://www.w3.org/2000/svg"
                                fill="currentColor"
                            />
                        </svg>
                    </div>
                {/if}
            </div>
        </div>
    {/each}
</div>
