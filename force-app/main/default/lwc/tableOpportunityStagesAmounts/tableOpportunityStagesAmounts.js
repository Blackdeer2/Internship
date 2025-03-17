import { LightningElement, api, wire, track } from 'lwc';
import getStagesWithTotalAmount from '@salesforce/apex/OpportunityService.getStagesWithTotalAmount';

const ALL_STAGES = [
    'Prospecting', 'Qualification', 'Needs Analysis', 'Value Proposition',
    'Id. Decision Makers', 'Perception Analysis', 'Proposal/Price Quote',
    'Negotiation/Review', 'Closed Won', 'Closed Lost'
];
export default class TableOpportunityStagesAmounts extends LightningElement {
    lol=ALL_STAGES;
    @api recordId;
    @track columns = [];
    @track tableData = [];
    @track data;
    isVertical = false;

    @wire(getStagesWithTotalAmount, { accountId: '$recordId' })
    wiredStages({ error, data }) {
        if (data) {
            console.log('Raw Data from Apex:', JSON.stringify(data));
            this.data = data;
            this.updateTable(data);

        } else if (error) {
            console.error('Error fetching stages with total amount:', error);
        }
    }

    updateTable(data){
        if(this.isVertical){
            this.generateVerticalTable(data);
        }else{
            this.generateHorizontalTable(data);
        }
    }

    generateHorizontalTable(data) {
        this.columns = [
            { label: 'Opportunity', fieldName: 'opportunityName', type: 'text' },
            ...ALL_STAGES.map(stage => ({
                label: stage,
                fieldName: stage,
                type: 'text'
            }))
        ];

        this.tableData = data.listOpp.map(opp => {
            let row = { opportunityName: opp.Name };
            ALL_STAGES.forEach(stage => {
                row[stage] = opp.StageName === stage ? opp.Amount : 0;
            });
            return row;
        });

        let totalRow = { opportunityName: 'Total Amount' };
        ALL_STAGES.forEach(stage => {
            totalRow[stage] = data.amounts[stage] || 0;
        });
        this.tableData.unshift(totalRow);
    }
    
    
    generateVerticalTable(data){

        this.columns = [
            { label: 'Stage', fieldName: 'stage', type: 'text' },
            { label: 'Total Amount', fieldName: 'totalAmount', type: 'currency' },
            { label: 'Opportunities', fieldName: 'opportunities', type: 'text' }
        ];

        this.tableData = ALL_STAGES.map(stage => ({
            id: stage,
            stage: stage,
            totalAmount: data.amounts[stage] || 0,
            opportunities: data.opportunities[stage] ? data.opportunities[stage].map(opp => opp.Name).join(', ') : '-'
        }));
    }

    handleSwitch(){
        this.isVertical =!this.isVertical;
        this.updateTable(this.data);
    }

    handleSectionToggle(event) {
        const openSections = event.detail.openSections;

        if (openSections.length === 0) {
            this.activeSectionsMessage = 'All sections are closed';
        } else {
            this.activeSectionsMessage =
                'Open sections: ' + openSections.join(', ');
        }
    }
}