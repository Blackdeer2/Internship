import { LightningElement, api, wire, track } from 'lwc';
import getStagesWithTotalAmount from '@salesforce/apex/OpportunityService.getStagesWithTotalAmount';

const ALL_STAGES = [
    'Prospecting', 'Qualification', 'Needs Analysis', 'Value Proposition',
    'Id. Decision Makers', 'Perception Analysis', 'Proposal/Price Quote',
    'Negotiation/Review', 'Closed Won', 'Closed Lost'
];
export default class TableOpportunityStagesAmounts extends LightningElement {
    stages=ALL_STAGES;
    @api recordId;
    @track columns = [];
    @track tableData = [];
    @track data;
    isVertical = false;
    opportunitiesByStage = {};

    @wire(getStagesWithTotalAmount, { accountId: '$recordId' })
    wiredStages({ error, data }) {
        if (data) {
            console.log('Raw Data from Apex:', JSON.stringify(data));
            this.data = data;
            this.generateHorizontalTable(data);
            this.opportunitiesByStage = this.processData(data);

        } else if (error) {
            console.error('Error fetching stages with total amount:', error);
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

    processData(data) {
        let stageData = {};
        this.stages.forEach(stage => {
            stageData[stage] = data.opportunities[stage] || [];
        });
        return stageData;
    }
    

    get opportunitiesList() {
        return this.stages.map(stage => {
            const opportunities = this.opportunitiesByStage[stage] || [];
            const totalAmount = opportunities.reduce((sum, opp) => sum + (opp.Amount || 0), 0);
            
            return {
                stageLabel: `${stage} - Total: $${totalAmount}`,
                opportunities
            };
        });
    }
      
    handleSwitch(){
        this.isVertical =!this.isVertical;
        this.updateTable(this.data);
    }
}