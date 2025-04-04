import { LightningElement, wire } from 'lwc';
import getOpportunityFlow from '@salesforce/apex/SankeyChartController.getOpportunityFlow';
import { loadScript } from 'lightning/platformResourceLoader';
import D3 from '@salesforce/resourceUrl/D3';

export default class SankeyChart extends LightningElement {
      renderedCallback() {
        
        if (this.isRendered) {
            return; 
        }
        this.isRendered = true;

        
        const script = document.createElement('script');
        script.src = D3; 
        script.onload = () => {
            this.drawSimpleRect(); 
        };
        document.body.appendChild(script);
    }

    drawSimpleRect() {

        const width = 500;
        const height = 300;

       
        const svg = d3.select(this.template.querySelector('.chartContainer'))
            .append('svg') 
            .attr('width', width)
            .attr('height', height);

        
        svg.append('rect')
            .attr('x', 50)
            .attr('y', 50)
            .attr('width', 400)
            .attr('height', 200)
            .attr('fill', 'steelblue');
    }
}