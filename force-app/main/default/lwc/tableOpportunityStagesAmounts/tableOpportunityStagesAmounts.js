import { LightningElement, api, wire, track } from 'lwc';
import getStagesWithTotalAmount from '@salesforce/apex/OpportunityService.getStagesWithTotalAmount';

const ALL_STAGES = [
    'Prospecting', 'Qualification', 'Needs Analysis', 'Value Proposition',
    'Id. Decision Makers', 'Perception Analysis', 'Proposal/Price Quote',
    'Negotiation/Review', 'Closed Won', 'Closed Lost'
];
export default class TableOpportunityStagesAmounts extends LightningElement {
    @api recordId;
    @track columns = [];
    @track tableData = [];
    isVertical = false;

    @wire(getStagesWithTotalAmount, { accountId: '$recordId' })
    wiredStages({ error, data }) {
        if (data) {
            console.log('Raw Data from Apex:', JSON.stringify(data));

            this.columns = ALL_STAGES.map(stage => ({
                label: stage,
                fieldName: stage,
                type: 'text'
            }));

            const rowDataTotal = { id: 'totalRow', label: 'Total Amount' };
            const rowDataOpportunities = { id: 'opportunitiesRow', label: 'Opportunities' };

            const amounts = data.amounts;
            const opportunities = data.opportunities;

            ALL_STAGES.forEach(stage => {
                rowDataTotal[stage] = amounts[stage];
                rowDataOpportunities[stage] = opportunities[stage] ? opportunities[stage].join('\n') : '-';
            });

            this.tableData = [rowDataTotal, rowDataOpportunities];

        } else if (error) {
            console.error('Error fetching stages with total amount:', error);
        }
    }
}