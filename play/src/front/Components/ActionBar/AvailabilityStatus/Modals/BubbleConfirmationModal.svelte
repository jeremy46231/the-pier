<script lang="ts">
    import { ConfirmationModalPropsInterface } from "../Interfaces/ConfirmationModalPropsInterface";
    import {
        bubbleModalVisibility,
        namePlayerInBubbleModalStore,
    } from "../../../../Stores/AvailabilityStatusModalsStore";
    import LL from "../../../../../i18n/i18n-svelte";
    import { passStatusToOnline } from "../../../../Rules/StatusRules/statusChangerFunctions";
    import ConfirmationModal from "./ConfirmationModal.svelte";

    const confirmationModalProps: ConfirmationModalPropsInterface = {
        handleAccept: () => {
            passStatusToOnline();
            bubbleModalVisibility.close();
        },
        handleClose: () => {
            bubbleModalVisibility.close();
        },
        acceptLabel: $LL.statusModal.accept(),
        closeLabel: $LL.statusModal.close(),
    };
</script>

<ConfirmationModal props={confirmationModalProps}>
    <div id="acceptDiscussion" class="tw-grow tw-text-center tw-text-xl">
        {$LL.notification.discussion({ name: $namePlayerInBubbleModalStore })}
    </div>
</ConfirmationModal>
