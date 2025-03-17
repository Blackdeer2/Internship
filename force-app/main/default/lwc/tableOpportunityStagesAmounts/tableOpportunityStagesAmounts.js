import { LightningElement, api, wire, track } from 'lwc';
import getStagesWithTotalAmount from '@salesforce/apex/OpportunityService.getStagesWithTotalAmount';

const ALL_STAGES = [
    'Prospecting', 'Qualification', 'Needs Analysis', 'Value Proposition',
    'Id. Decision Makers', 'Perception Analysis', 'Proposal/Price Quote',
    'Negotiation/Review', 'Closed Won', 'Closed Lost'
];
export default class tableOpportunityStagesAmounts extends LightningElement {

    @api recordId;
    @track columns = [];
    @track stagesData = [];

    @wire(getStagesWithTotalAmount, { accountId: '$recordId' })
    wiredStages({ error, data }) {
        if (data) {
            console.log('Raw Data from Apex:', data);
            
            this.columns = ALL_STAGES.map(stage => ({
                label: stage,
                fieldName: stage,
                type: 'currency'
            }));

            const rowData = { id: 'totalRow' };
            Object.keys(data).forEach(stage => {
                rowData[stage] = data[stage];
            });

            this.tableData = [rowData];

        } else if (error) {
            console.error('Error fetching stages with total amount:', error);
        }
    }
}