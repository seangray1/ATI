public without sharing class BudgetLineItemFieldUpdate {

    public static void LineItemFieldUpdate(List<Budget_Line_Item__c> LineItem){
        
        List<string> TradePickValue = new List<string>();
        //Get the Picklist Values
        Schema.SObjectType s = Schema.getGlobalDescribe().get('Budget_Line_Item__c') ;
        Schema.DescribeSObjectResult r = s.getDescribe() ;
        Map<String,Schema.SObjectField> fields = r.fields.getMap() ;
        Schema.DescribeFieldResult fieldResult = fields.get('Trade_Option__c').getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        for( Schema.PicklistEntry pickListVal : ple){
            TradePickValue.add(pickListVal.getValue().toUpperCase());
        }
        
        for(Budget_Line_Item__c b: LineItem){
            String TradeValue = '';
            
            if(String.isNotBlank(b.Item_Description__c)){
                String ItemDesc = b.Item_Description__c;
                ItemDesc = ItemDesc.replaceAll('&quot;','"');
                ItemDesc = ItemDesc.replaceAll('&amp;','&');
                ItemDesc = ItemDesc.replaceAll('&apos;','\'');
                b.Item_Description__c = ItemDesc;
            }
            
            if(String.isNotBlank(b.Selector_Full__c)){
                String SelectorFull = b.Selector_Full__c;
                SelectorFull = SelectorFull.replaceAll('&quot;','"');
                SelectorFull = SelectorFull.replaceAll('&gt;','>');
                SelectorFull = SelectorFull.replaceAll('&lt;','<');
                SelectorFull = SelectorFull.replaceAll('&amp;','&');
                SelectorFull = SelectorFull.replaceAll('&apos;','\'');
                b.Selector__c = SelectorFull.left(6);
            }
            
            
            if(String.isNotBlank(b.Trade__c)){
                String SearchValue = b.Trade__c;
                for(string bp: TradePickValue){
                    if(bp.startsWithIgnoreCase(SearchValue.toUpperCase())){
                       TradeValue = bp;
                    }
                }
                system.debug('Before Trade: '+TradeValue);
                if(String.isNotBlank(TradeValue)){
                    system.debug('TradePick: '+TradeValue);
                    b.Trade_Option__c  = TradeValue;
                    b.Trade__c = TradeValue;
                }
            }
        }
    
    }
    
    public static void InsertErrortLogForTrade(List<Budget_Line_Item__c> BugetLineItem){
        List<Jitterbit_Log__c> JitLogList = new List<Jitterbit_Log__c>();
        for(Budget_Line_Item__c Bl: BugetLineItem){
            if(bl.Trade_Option__c  =='Others'){
                Jitterbit_Log__c Jl = new Jitterbit_Log__c();
                Jl.Status__c='Warning';
                Jl.Name = 'Estimate - Buget Line Item Trade Option mismatch';
                Jl.Error_Warning_Details__c = 'There is a mismatch value coming from Xact for Trade - '+bl.Trade__c;
                Jl.XASP_Transaction_ID__c = '';
                Jl.Record_ID__c =bl.id;
                Jl.Source_System__c = 'XASP';
                Jl.Destination_System__c ='ATI Salesforce'; 
                JitLogList .add(Jl);               
            }
        }
        if(JitLogList.size() > 0){
            insert JitLogList;
        }
    }
    
    //BOF Method to update Parent Estimates -- By DemandBlue
    public static void CreateParentforEstimateItem(List<Budget_Line_Item__c> LineItems, Map<Id,Budget_Line_Item__c> OldLineItemsMap){
        Map < Id, List < Budget_Line_Item__c > > BudgetMap = BudgetLineItemFieldUpdate.GetAllBudgetLineItemMap(LineItems);
        List<Budget_Line_Item__c> UpsertBLIList = new List<Budget_Line_Item__c>();
        Set<id> BypassCalculationList = new Set<id>();
        List<Budget_Line_Item__c> AllBudgetLI = new List<Budget_Line_Item__c>();    
        system.debug('Total IDs received--------> '+LineItems.size());
        for(Budget_Line_Item__c d: LineItems){
                system.debug('Received ID--------> '+d.Id);
            }
        for (Id IterateBudgetId : BudgetMap.keySet()){ //Main Budget Map Loop
            AllBudgetLI=new list<Budget_Line_Item__c>();
            AllBudgetLI = BudgetMap.get(IterateBudgetId);
        
        
        if(OldLineItemsMap != null){
        for(Budget_Line_Item__c d: LineItems){
                Budget_Line_Item__c oldValues = OldLineItemsMap.get(d.ID);
            System.debug('ID------------------>'+d.ID);
              if(d.In_House_Hours__c != oldValues.In_House_Hours__c) {
                System.debug('Inhours changed' + ' in house hours ' + d.In_House_Hours__c + ' old ' + oldValues.In_House_Hours__c);
                    System.debug(d.In_House_Hours__c);
                    System.debug(oldValues.In_House_Hours__c);
              }
                if(d.Equipment__c != oldValues.Equipment__c) {
                        System.debug('Equipment__c changed');
                    System.debug(d.Equipment__c);
                    System.debug(oldValues.Equipment__c);
                    }
                if(d.Materials__c != oldValues.Materials__c) {
                        System.debug('Materials__c changed');
                    System.debug(d.Materials__c);
                    System.debug(oldValues.Materials__c);
                    }
                if(d.In_House_Rate__c != oldValues.In_House_Rate__c) {
                        System.debug('In_House_Rate__c changed');
                    System.debug(d.In_House_Rate__c);
                    System.debug(oldValues.In_House_Rate__c);
                    }
                if(d.GP__c != oldValues.GP__c) {
                        System.debug('GP__c changed');
                    System.debug(d.GP__c);
                    System.debug(oldValues.GP__c);
                    }
              if(d.Other_Costs__c != oldValues.Other_Costs__c) {
                        System.debug('Other_Costs__c changed');
                    System.debug(d.Other_Costs__c);
                    System.debug(oldValues.Other_Costs__c);
                    }
            if(d.Bypass_Calculation__c != oldValues.Bypass_Calculation__c) {
                        System.debug('Bypass_Calculation__c changed');
                    System.debug(d.Bypass_Calculation__c);
                    System.debug(oldValues.Bypass_Calculation__c);
                    }
            }
    }
        
        for(integer i=0;i<LineItems.size();i++) { //I Loop
            String NewPTrade =''; String NewPSelector =''; Id NewPBLIId =null;
            Decimal NewPRevenue =0; Decimal LineItemPRevenue =0; Decimal EachLineItemPRevenue =0;
            Decimal NewPEquipment =0; Decimal LineItemPEquipment =0; Decimal EachLineItemPEquipment =0;
            Decimal NewPInhouseHours =0; Decimal LineItemPInhouseHours =0; Decimal EachLineItemPInhouseHours =0;
            Decimal NewPMaterials =0; Decimal LineItemPMaterials =0; Decimal EachLineItemPMaterials =0; Decimal NewSubContractBid =0;           
            Decimal NewPInHouseRate =0; Decimal LineItemPInHouseRate =0; Decimal EachLineItemPInHouseRate =0;
            Decimal NewPGP =0; Decimal LineItemPGP =0; Decimal EachLineItemPGP =0;
            Decimal NewPOtherCost =0; Decimal LineItemPOtherCost =0; Decimal EachLineItemPOtherCost =0;
            Decimal InHouseCal =0;Decimal GPCal = 0;
            Decimal NewActualCostBL = 0;
            List<Budget_Line_Item__c> ArrayValtoRemov = new List<Budget_Line_Item__c>();
            List<Budget_Line_Item__c> ArrayValtoKeep = new List<Budget_Line_Item__c>();
            Budget_Line_Item__c UpsertBLIData = new Budget_Line_Item__c();

            for(integer j=0;j<AllBudgetLI.size();j++) { //J Loop
                system.debug('%%%%%%%%%'+LineItems[i].Trade__c);
                system.debug('**********'+AllBudgetLI[j].Trade__c);
                system.debug('$$$$$$$$$$'+AllBudgetLI[j].Is_sub_Parent__c);
                system.debug('&&&&&&&&&&'+LineItems[i].Is_sub_Parent__c);
                system.debug('^^^^^^^^^^'+LineItems[i].Bypass_Calculation__c);
                 //BOF of Parent Calcuation
                 if(LineItems[i].Trade__c == AllBudgetLI[j].Trade__c && AllBudgetLI[j].Is_sub_Parent__c && LineItems[i].Is_sub_Parent__c && !LineItems[i].Bypass_Calculation__c){
                    NewPTrade = LineItems[i].Trade__c;
                    //Revenue
                    if(AllBudgetLI[j].Revenue__c!=null && AllBudgetLI[j].Is_sub_Parent__c){
                        NewPRevenue = NewPRevenue + AllBudgetLI[j].Revenue__c;
                    }

                    //Equipment
                    if(AllBudgetLI[j].Equipment__c!=null && AllBudgetLI[j].Is_sub_Parent__c){
                        NewPEquipment = NewPEquipment + AllBudgetLI[j].Equipment__c;
                    }                    


                    //InhouseHours
                    if(AllBudgetLI[j].In_House_Hours__c!=null && AllBudgetLI[j].Is_sub_Parent__c){
                        NewPInhouseHours = NewPInhouseHours + AllBudgetLI[j].In_House_Hours__c;
                    }

                    //SubContractBid
                    if(AllBudgetLI[j].Subcontractor_bid__c!=null && AllBudgetLI[j].Is_sub_Parent__c){
                        NewSubContractBid = NewSubContractBid + AllBudgetLI[j].Subcontractor_bid__c;
                    }

                    //Materials
                    if(AllBudgetLI[j].Materials__c!=null && AllBudgetLI[j].Is_sub_Parent__c){
                        NewPMaterials = NewPMaterials + AllBudgetLI[j].Materials__c;
                    }
                    
                    //Actual Cost BL
                    if(AllBudgetLI[j].Actual_Costs_BL__c!=null && AllBudgetLI[j].Is_sub_Parent__c){
                        NewActualCostBL = NewActualCostBL + AllBudgetLI[j].Actual_Costs_BL__c;
                    }
                    

                    //InHouseRate
                    /*
                    System.debug('FIRST--NewPInHouseRate------'+NewPInHouseRate);
                    if(AllBudgetLI[j].In_House_Rate__c!=null && AllBudgetLI[j].Is_sub_Parent__c && AllBudgetLI[j].Revenue__c!=null){
                        InHouseCal = InHouseCal + (AllBudgetLI[j].In_House_Rate__c * AllBudgetLI[j].Revenue__c);
                        System.debug('OtherChildRate------'+AllBudgetLI[j].In_House_Rate__c);                        
                        if(InHouseCal!=0){
                            NewPInHouseRate = InHouseCal/NewPRevenue;
                            System.debug('NewPRevenue---------->'+NewPRevenue);
                            System.debug('InHouseCal---------->'+InHouseCal);
                        }
                    }
                    System.debug('Final Rate Value------->'+NewPInHouseRate);
                     */
                     //After new change requested -- 202 to 211 -- Updated by Demandblue
                     if(AllBudgetLI[j].In_House_Rate__c!=null && AllBudgetLI[j].Is_sub_Parent__c && AllBudgetLI[j].In_House_Hours__c!=null){
                        InHouseCal = InHouseCal + (AllBudgetLI[j].In_House_Rate__c * AllBudgetLI[j].In_House_Hours__c);
                        System.debug('OtherChildRate------'+AllBudgetLI[j].In_House_Rate__c);                        
                        if(InHouseCal!=0){
                            NewPInHouseRate = InHouseCal/NewPInhouseHours;
                            System.debug('NewPInhouseHours---------->'+NewPInhouseHours);
                            System.debug('InHouseCal---------->'+InHouseCal);
                        }
                    }
                    System.debug('Final Rate Value------->'+NewPInHouseRate);
                    

                    //GP
                    System.debug('FIRST--NewPGP------'+NewPGP);
                    if(AllBudgetLI[j].GP__c!=null && AllBudgetLI[j].Is_sub_Parent__c && AllBudgetLI[j].Revenue__c!=null){
                        GPCal = GPCal + (AllBudgetLI[j].GP__c * AllBudgetLI[j].Revenue__c);
                        System.debug('OtherChildRate------'+AllBudgetLI[j].GP__c);                        
                        if(GPCal!=0){
                            NewPGP = GPCal/NewPRevenue;
                            System.debug('NewPRevenue---------->'+NewPRevenue);
                            System.debug('GPCal---------->'+GPCal);
                        }
                    }
                    System.debug('Final Rate Value------->'+NewPGP);

                    
                    //OtherCost
                    if(AllBudgetLI[j].Other_Costs__c!=null && AllBudgetLI[j].Is_sub_Parent__c){
                        NewPOtherCost = NewPOtherCost + AllBudgetLI[j].Other_Costs__c;
                    }
                    system.debug('LIHR: '+LineItemPInHouseRate+' EachLIHR: '+EachLineItemPInHouseRate);
                    System.debug('NewPInHouseRate------'+NewPInHouseRate);
                    System.debug('NewPRevenue----------'+NewPRevenue);
                    System.debug('LineItems[i].In_House_Rate__c--------------'+LineItems[i].In_House_Rate__c);
                    System.debug('LineItems[i].Revenue__c----------'+LineItems[i].Revenue__c);
                    System.debug('LineItems[i].Revenue__c----------'+LineItems[i].id);
                    

                    ArrayValtoRemov.add(AllBudgetLI[j]);
                } //EOF of Parent Calcuation
                else if (LineItems[i].Bypass_Calculation__c){
                    BypassCalculationList.add(LineItems[i].id);
                }
                system.debug('J Val: '+j+'-'+AllBudgetLI[j].Id +'-'+ AllBudgetLI[j].Is_Parent__c +'-'+ LineItems[i].Trade__c +'-'+ AllBudgetLI[j].Trade__c);
                
                if(LineItems[i].Trade__c == AllBudgetLI[j].Trade__c && AllBudgetLI[j].Is_Parent__c ){
                    system.debug('NEBLId: '+AllBudgetLI[j].Id);
                    NewPBLIId = AllBudgetLI[j].Id;
                }
                system.debug('UpsertId: '+NewPBLIId);
            } //EOF J Loop
        
            //Remove from List
            for(Budget_Line_Item__c d: ArrayValtoKeep){
                system.debug('Keep Id: '+d.Id);
            }
            for(Integer R=0; R<ArrayValtoRemov.size(); R++){
                for(Integer M=0; M<AllBudgetLI.size(); M++){
                    if(ArrayValtoRemov[R].Id==AllBudgetLI[M].Id){
                        AllBudgetLI.remove(M);
                    }
                }
            }
            
            system.debug('Np'+NewPTrade);
            System.debug('LineItems[i].Budget__c-------->'+LineItems[i].Budget__c);
            if(NewPTrade!=''){
                    if(OldLineItemsMap != null){
                        System.debug('Inside Final IFFFF to update');
              Budget_Line_Item__c oldValues = OldLineItemsMap.get(LineItems[i].ID);                     

                      //UpsertBLIData.Trade__c = NewPTrade;
                            UpsertBLIData.Trade__c = LineItems[i].Trade__c;
                            UpsertBLIData.Selector__c = '';
                            UpsertBLIData.Revenue__c = NewPRevenue;
                            UpsertBLIData.Budget__c = LineItems[i].Budget__c;
                            UpsertBLIData.Trade_Option__c = LineItems[i].Trade_Option__c;
                            UpsertBLIData.Is_Parent__c = true;                       
                            UpsertBLIData.DonotDelete__c = true;
                            UpsertBLIData.Bypass_Calculation__c = false;
                            UpsertBLIData.Id = NewPBLIId;
                            if(LineItems[i].Subcontractor_bid__c != oldValues.Subcontractor_bid__c) {
                                UpsertBLIData.Subcontractor_bid__c = NewSubContractBid.setscale(2);
                            }
                            if(LineItems[i].In_House_Hours__c != oldValues.In_House_Hours__c) {
                                UpsertBLIData.In_House_Hours__c = NewPInhouseHours.round();
                            }
                            if(LineItems[i].Equipment__c != oldValues.Equipment__c) {
                                    UpsertBLIData.Equipment__c = NewPEquipment.setscale(2);
                                }
                            if(LineItems[i].Materials__c != oldValues.Materials__c) {
                                    UpsertBLIData.Materials__c = NewPMaterials.setscale(2);
                                }
                            if((LineItems[i].In_House_Rate__c != oldValues.In_House_Rate__c)|| (LineItems[i].In_House_Hours__c != oldValues.In_House_Hours__c)) {
                                    UpsertBLIData.In_House_Rate__c = NewPInHouseRate.setscale(2);
                                    system.debug('In house rate full ' + UpsertBLIData.In_House_Rate_Full__c);
                                	UpsertBLIData.In_House_Rate_Full__c = NewPInHouseRate;
                                } 
                            if(NewPInHouseRate!=0){
                                UpsertBLIData.In_House_Rate_Full__c = NewPInHouseRate;
                            } else {
                                UpsertBLIData.In_House_Rate_Full__c = LineItems[i].In_House_Rate__c;
                            }
                        	
                            if(LineItems[i].GP__c != oldValues.GP__c) {
                                    UpsertBLIData.GP__c = NewPGP.setscale(2);
                                }
                            if(LineItems[i].Other_Costs__c != oldValues.Other_Costs__c) {
                                    UpsertBLIData.Other_Costs__c = NewPOtherCost.setscale(2);
                                }
                        
                            

                            UpsertBLIData.In_House_Total_BL__c = LineItems[i].In_House_Total__c;
                        
                        UpsertBLIList.add(UpsertBLIData);
                    }
                else{
                    System.debug('Inside Final else to update');
                        //UpsertBLIData.Trade__c = NewPTrade;
                        UpsertBLIData.Trade__c = LineItems[i].Trade__c;
                        UpsertBLIData.Trade_Option__c = LineItems[i].Trade_Option__c;
                            UpsertBLIData.Selector__c = '';
                            UpsertBLIData.Revenue__c = NewPRevenue;
                            UpsertBLIData.Equipment__c = NewPEquipment.setscale(2);
                            UpsertBLIData.Materials__c = NewPMaterials.setscale(2);
                            UpsertBLIData.Subcontractor_bid__c = NewSubContractBid.setscale(2);
                            UpsertBLIData.In_House_Hours__c = NewPInhouseHours.setscale(2);
                            UpsertBLIData.In_House_Rate__c = NewPInHouseRate.setscale(2);
                    		UpsertBLIData.In_House_Rate_Full__c = NewPInHouseRate;
                            UpsertBLIData.GP__c = NewPGP.setscale(2);
                            UpsertBLIData.Other_Costs__c = NewPOtherCost.setscale(2);
                            UpsertBLIData.Budget__c = LineItems[i].Budget__c;
                            UpsertBLIData.X10_10_Allocation__c = LineItems[i].X10_10_Allocation__c;
                            UpsertBLIData.Is_Parent__c = true;
                            UpsertBLIData.Bypass_Calculation__c = false;
                            UpsertBLIData.DonotDelete__c = true;        
                            UpsertBLIData.Id = NewPBLIId;
                    
                            //UpsertBLIData.Actual_Costs_BL__c = NewActualCostBL;

                            UpsertBLIData.In_House_Total_BL__c = LineItems[i].In_House_Total__c;
                            
                            UpsertBLIList.add(UpsertBLIData);
                }
            }
        } //EOF I Loop
    } //EOF Main Budget Map Loop
        system.debug('Upsert List: '+UpsertBLIList);
        List<Budget_Line_Item__c> UpdatenewLineitems = new List<Budget_Line_Item__c>();
        //Upsert list.
        if(BypassCalculationList.size()>0){
            for(Id BLIID : BypassCalculationList){
                Budget_Line_Item__c BLI = new Budget_Line_Item__c();
                BLI.Id = BLIID;
                BLI.Bypass_Calculation__c = false;
                UpdatenewLineitems.add(BLI);
            }
        }
        if(UpdatenewLineitems.size()>0){
            upsert(UpdatenewLineitems);
        }
        if(UpsertBLIList.size()>0){
            upsert(UpsertBLIList);
        }
    } //EOF Method to update Parent Estimates
    
    // BOF Method to Update Sub-Parent Estimates - By DemandBlue
    public static void CreateSubParentforEstimateItem(List<Budget_Line_Item__c> LineItems){
        system.debug('Incoming size: '+LineItems.size()+' Data: '+LineItems);
        List<Budget_Line_Item__c> LineItemsNew = new List<Budget_Line_Item__c>();
        Map < Id, List < Budget_Line_Item__c > > BudgetMap = BudgetLineItemFieldUpdate.GetAllBudgetLineItemMap(LineItems);
        system.debug('BLIMap:  '+BudgetMap);
        List<Budget_Line_Item__c> UpsertBLIList = new List<Budget_Line_Item__c>();
        List<Budget_Line_Item__c> AllBudgetLI = new List<Budget_Line_Item__c>();
        for (Id IterateBudgetId : BudgetMap.keySet()){ //Main Budget Map Loop
            AllBudgetLI = new List<Budget_Line_Item__c>();
            AllBudgetLI = BudgetMap.get(IterateBudgetId);
        
          system.debug('AllBudget size: '+AllBudgetLI.size()+' Data: '+AllBudgetLI);  
        for(integer i=0;i<LineItems.size();i++) { //I Loop
            String NewSPTrade =''; String NewSPSelector =''; Id NewSPBLIId =null;
            Decimal NewSPRevenue =0; Decimal LineItemSPRevenue =0; Decimal EachLineItemSPRevenue =0;
            Decimal NewSPInhouseHours =0; Decimal LineItemSPInhouseHours =0; Decimal EachLineItemSPInhouseHours =0; Decimal NewSubContractBid =0;
            Decimal NewSPMaterial =0; Decimal LineItemSPMaterial =0; Decimal EachLineItemSPMaterial =0;
            Decimal NewSPEquipment =0; Decimal LineItemSPEquipment =0; Decimal EachLineItemSPEquipment =0;
            Decimal NewSPInHouseRate =0; Decimal LineItemSPInHouseRate =0; Decimal EachLineItemSPInHouseRate =0; Decimal InHouseCal =0;
            Decimal NewSPGP =0; Decimal LineItemSPGP =0; Decimal EachLineItemSPGP =0; Decimal GPCal = 0;
            Decimal NewSPOtherCost =0; Decimal LineItemSPOtherCost =0; Decimal EachLineItemSPOtherCost =0;
            List<Budget_Line_Item__c> ArrayValtoRemov = new List<Budget_Line_Item__c>();
            List<Budget_Line_Item__c> ArrayValtoKeep = new List<Budget_Line_Item__c>();
            Budget_Line_Item__c UpsertBLIData = new Budget_Line_Item__c();
            system.debug('Inside For I: '+LineItems[i].Id+'-'+LineItems[i].Trade__c+'-'+LineItems[i].Selector__c);
            system.debug('AllBudge Size: '+AllBudgetLI.size());
            for(integer j=0;j<AllBudgetLI.size();j++) { //J Loop
                //NewSPTrade =''; NewSPSelector ='';
                //BOF Sub Parent Calcuation
                system.debug('Inside For J: '+j+'='+AllBudgetLI[j].Id+'-'+AllBudgetLI[j].Trade__c+'-'+AllBudgetLI[j].Selector__c);
                //if(LineItems[i].From_Xact__c && AllBudgetLI[j].From_Xact__c && LineItems[i].Trade__c == AllBudgetLI[j].Trade__c && LineItems[i].Selector__c == AllBudgetLI[j].Selector__c && LineItems[i].Id!=AllBudgetLI[j].Id){
                if(LineItems[i].From_Xact__c && AllBudgetLI[j].From_Xact__c && LineItems[i].Trade__c == AllBudgetLI[j].Trade__c && LineItems[i].Selector__c == AllBudgetLI[j].Selector__c ){
                    system.debug('Inside For J IF Con: '+j+'-'+AllBudgetLI[j].Id+'-'+AllBudgetLI[j].Trade__c+'-'+AllBudgetLI[j].Selector__c);
                    NewSPTrade = LineItems[i].Trade__c;
                    NewSPSelector = LineItems[i].Selector__c;
                    
                    //Revenue
                    if(AllBudgetLI[j].Revenue__c!=null){
                        NewSPRevenue = NewSPRevenue + AllBudgetLI[j].Revenue__c;
                    }
                    /*if(LineItems[i].Revenue__c!=null){
                         LineItemSPRevenue = LineItems[i].Revenue__c;
                    }
                    if(AllBudgetLI[j].Revenue__c!=null){
                        EachLineItemSPRevenue = AllBudgetLI[j].Revenue__c;
                    }
                    if(NewSPRevenue==0){
                        NewSPRevenue = LineItemSPRevenue + EachLineItemSPRevenue;
                    } else{
                        NewSPRevenue = NewSPRevenue + EachLineItemSPRevenue;
                    }*/

                    //SubContract Bid
                    if(AllBudgetLI[j].Subcontractor_bid__c!=null){
                        NewSubContractBid = NewSubContractBid + AllBudgetLI[j].Subcontractor_bid__c;
                    }

                    //InhouseHours
                    if(AllBudgetLI[j].In_House_Hours__c!=null){
                        NewSPInhouseHours = NewSPInhouseHours + AllBudgetLI[j].In_House_Hours__c;
                    }
                    /*if(LineItems[i].In_House_Hours__c!=null){
                         LineItemSPInhouseHours = LineItems[i].In_House_Hours__c;
                    }
                    if(AllBudgetLI[j].In_House_Hours__c!=null){
                        EachLineItemSPInhouseHours = AllBudgetLI[j].In_House_Hours__c;
                    }
                    if(NewSPInhouseHours==0){
                        NewSPInhouseHours = LineItemSPInhouseHours + EachLineItemSPInhouseHours;
                    } else{
                        NewSPInhouseHours = NewSPInhouseHours + EachLineItemSPInhouseHours;
                    }*/
                    
                    
                    //Material
                    if(AllBudgetLI[j].Materials__c!=null){
                        NewSPMaterial = NewSPMaterial + AllBudgetLI[j].Materials__c;
                    }
                    /*if(LineItems[i].Materials__c!=null){
                         LineItemSPMaterial = LineItems[i].Materials__c;
                    }
                    if(AllBudgetLI[j].Materials__c!=null){
                        EachLineItemSPMaterial = AllBudgetLI[j].Materials__c;
                    }
                    if(NewSPMaterial==0){
                        NewSPMaterial = LineItemSPMaterial + EachLineItemSPMaterial;
                    } else{
                        NewSPMaterial = NewSPMaterial + EachLineItemSPMaterial;
                    }*/


                    //Equipment
                    if(AllBudgetLI[j].Equipment__c!=null){
                        NewSPEquipment = NewSPEquipment + AllBudgetLI[j].Equipment__c;
                    }
                    /*if(LineItems[i].Equipment__c!=null){
                         LineItemSPEquipment = LineItems[i].Equipment__c;
                    }
                    if(AllBudgetLI[j].Equipment__c!=null){
                        EachLineItemSPEquipment = AllBudgetLI[j].Equipment__c;
                    }
                    if(NewSPEquipment==0){
                        NewSPEquipment = LineItemSPEquipment + EachLineItemSPEquipment;
                    } else{
                        NewSPEquipment = NewSPEquipment + EachLineItemSPEquipment;
                    }*/
                    
                    //OtherCost
                    if(AllBudgetLI[j].Other_Costs__c!=null){
                        NewSPOtherCost = NewSPOtherCost + AllBudgetLI[j].Other_Costs__c;
                    }
                    /*if(LineItems[i].Other_Costs__c!=null){
                         LineItemSPOtherCost = LineItems[i].Other_Costs__c;
                    }
                    if(AllBudgetLI[j].Other_Costs__c!=null){
                        EachLineItemSPOtherCost = AllBudgetLI[j].Other_Costs__c;
                    }
                    if(NewSPOtherCost==0){
                        NewSPOtherCost = LineItemSPOtherCost + EachLineItemSPOtherCost;
                    } else{
                        NewSPOtherCost = NewSPOtherCost + EachLineItemSPOtherCost;
                    }*/

                    

                    //InHouseRate
                    if(AllBudgetLI[j].In_House_Rate__c!=null){
                        if(InHouseCal == 0){
                           InHouseCal =  AllBudgetLI[j].In_House_Rate__c;
                            NewSPInHouseRate = InHouseCal;
                        } else{
                            InHouseCal = (InHouseCal + AllBudgetLI[j].In_House_Rate__c);
                            if(InHouseCal!=0){
                                //NewSPInHouseRate = InHouseCal/NewSPRevenue; After new change -- based on Revenue to Hours
                                NewSPInHouseRate = InHouseCal/NewSPInhouseHours;
                            }
                        }
                    }
                    /*if(LineItems[i].In_House_Rate__c!=null){
                         LineItemSPInHouseRate = LineItems[i].In_House_Rate__c * LineItemSPRevenue;
                    }
                    if(AllBudgetLI[j].In_House_Rate__c!=null){
                        EachLineItemSPInHouseRate = AllBudgetLI[j].In_House_Rate__c * EachLineItemSPRevenue;
                    }
                    if(NewSPInHouseRate==0){
                        NewSPInHouseRate = (LineItemSPInHouseRate + EachLineItemSPInHouseRate) / NewSPRevenue;
                    } else{
                        NewSPInHouseRate = (NewSPInHouseRate + EachLineItemSPInHouseRate) / NewSPRevenue;
                    }*/

                    //GP
                    if(AllBudgetLI[j].GP__c!=null){
                        if(GPCal == 0){
                           GPCal =  AllBudgetLI[j].GP__c;
                            NewSPGP = GPCal;
                        } else{
                            GPCal = (GPCal + AllBudgetLI[j].GP__c);
                            if(GPCal!=0){
                                NewSPGP = GPCal/NewSPRevenue;
                            }
                        }
                    }
                    /*if(LineItems[i].GP__c!=null){
                         LineItemSPGP = LineItems[i].GP__c * LineItemSPRevenue;
                    }
                    if(AllBudgetLI[j].GP__c!=null){
                        EachLineItemSPGP = AllBudgetLI[j].GP__c * EachLineItemSPRevenue;
                    }
                    if(NewSPGP==0){
                        NewSPGP = (LineItemSPGP + EachLineItemSPGP) / NewSPRevenue;
                    } else{
                        NewSPGP = (NewSPGP + EachLineItemSPGP) / NewSPRevenue;
                    }*/

                    
                    ArrayValtoRemov.add(AllBudgetLI[j]);
                } // EOF Sub Parent Calcualtion
               /* else{
                    ArrayValtoKeep.add(AllBudgetLI[j]);
                }*/
               
                if(AllBudgetLI[j].Is_sub_Parent__c && LineItems[i].Trade__c == AllBudgetLI[j].Trade__c && LineItems[i].Selector__c == AllBudgetLI[j].Selector__c ){
                    NewSPBLIId = AllBudgetLI[j].Id;
                }
               // system.debug('J Val: '+j+'-'+AllBudgetLI[j].Id +'-'+ AllBudgetLI[j].Is_sub_Parent__c +'-'+ LineItems[i].Trade__c +'-'+ AllBudgetLI[j].Trade__c);
                //system.debug('Matcing Id: '+NewSPBLIId);
                
            } //EOF J Loop
            
            //Remove from List
            for(Budget_Line_Item__c d: ArrayValtoKeep){
                system.debug('Keep Id: '+d.Id);
            }
            
            
            /*if(ArrayValtoKeep.size()>0){
                AllBudgetLI.clear();
                AllBudgetLI=ArrayValtoKeep;
            }*/
            /*for(Integer R = AllBudgetLI.size() - 1; R >= 0; R--) {
                if(AllBudgetLI[R].equals(ArrayValtoRemov)) {
                    AllBudgetLI.remove(R);
                }
            }*/
            for(Integer R=0; R<ArrayValtoRemov.size(); R++){
                for(Integer M=0; M<AllBudgetLI.size(); M++){
                    if(ArrayValtoRemov[R].Id==AllBudgetLI[M].Id){
                        AllBudgetLI.remove(M);
                    }
                }
            }
            /*if(ArrayValtoRemov.size()>0){ 
                for(R=0;R<ArrayValtoRemov.size();R++){
                           
                }
            }*/
            
            if(NewSPTrade!=''){
                UpsertBLIData.Trade__c = NewSPTrade;
                UpsertBLIData.Selector__c = NewSPSelector;
                UpsertBLIData.Revenue__c = NewSPRevenue;
                UpsertBLIData.Materials__c = NewSPMaterial.setscale(2);
                UpsertBLIData.Subcontractor_bid__c = NewSubContractBid.setscale(2);
                UpsertBLIData.In_House_Hours__c = NewSPInhouseHours.setscale(2);
                UpsertBLIData.Equipment__c = NewSPEquipment.setscale(2);
                UpsertBLIData.In_House_Rate__c = NewSPInHouseRate.setscale(2);
                UpsertBLIData.In_House_Rate_Full__c = NewSPInHouseRate;
                UpsertBLIData.GP__c = NewSPGP.setscale(2);
                UpsertBLIData.Other_Costs__c = NewSPOtherCost.setscale(2);
                UpsertBLIData.Budget__c = LineItems[i].Budget__c;
                UpsertBLIData.Item_Description__c = LineItems[i].Item_Description__c;
                UpsertBLIData.Trade_Option__c = LineItems[i].Trade_Option__c;
                UpsertBLIData.DonotDelete__c = LineItems[i].From_Xact__c;
                UpsertBLIData.X10_10_Allocation__c = LineItems[i].X10_10_Allocation__c;

                UpsertBLIData.Equipment_BL__c = LineItems[i].Equipment_BL__c;
                UpsertBLIData.Actual_Costs_BL__c = LineItems[i].Actual_Costs__c;
                UpsertBLIData.In_House_Hours_BL__c = LineItems[i].In_House_Hours_BL__c;
                UpsertBLIData.In_House_Rate_BL__c = LineItems[i].In_House_Rate_BL__c;
                UpsertBLIData.In_House_Total_BL__c = LineItems[i].In_House_Total__c;
                UpsertBLIData.Materials_BL__c = LineItems[i].Materials_BL__c;
                UpsertBLIData.Other_Costs_BL__c = LineItems[i].Other_Costs_BL__c;

                UpsertBLIData.Is_sub_Parent__c = true;                
                UpsertBLIData.Bypass_Calculation__c = false;
                UpsertBLIData.Id = NewSPBLIId;
                UpsertBLIList.add(UpsertBLIData);
            }
            
        } //EOF I Loop
    } //EOF Main Budget Map Loo    
        system.debug('Upsert Size:'+UpsertBLIList.size()+'Upsert SP List: '+UpsertBLIList);
        //Upsert list.
        if(UpsertBLIList.size()>0){
            try {
                List<Database.Saveresult> insertResults = Database.Insert(UpsertBLIList, false );
                List<Id> listOfIds = new List<Id>();
                for (Database.SaveResult sr : insertResults) {
                    if (sr.isSuccess()) {
                        listOfIds.add(sr.getId());
                        system.debug('Inserted ID--------> '+sr.getId());
                    }
                    else {
                    // Operation failed, so get all errors                
                    for(Database.Error err : sr.getErrors()) {
                        System.debug('The following error has occurred.');                    
                        System.debug(err.getStatusCode() + ': ' + err.getMessage());
                        System.debug('Account fields that affected this error: ' + err.getFields());
        }
    }
                }
            system.debug('Total subparent created--------> '+UpsertBLIList.size());

            LineItemsNew.addAll(UpsertBLIList);
            LineItemsNew.addAll(LineItems);    
            } catch(DmlException e) {
                System.debug('The following exception has occurred: ' + e.getMessage());
            }
            
            //LineItems.addAll(UpsertBLIList);
            BudgetLineItemFieldUpdate.CreateParentforEstimateItem(LineItemsNew,null);
        }
        Else{
            BudgetLineItemFieldUpdate.CreateParentforEstimateItem(LineItems,null);
        }
    } // EOD Method to Update Sub-Parent Estimates

    
    //BOF Method to get All Budget-LI - By DemandBlue
    public static Map< Id, List < Budget_Line_Item__c >> GetAllBudgetLineItemMap(List<Budget_Line_Item__c> LineItems){
        Map < Id, List < Budget_Line_Item__c > > AllBudgetLIMap = new Map < Id, List < Budget_Line_Item__c > > ();
        Set < Id > BudgetIds = new Set < Id > ();
        List < Budget_Line_Item__c > AllLineItems = new List < Budget_Line_Item__c > ();
        
        for (Budget_Line_Item__c LineItem: LineItems) {
            BudgetIds.add(LineItem.Budget__c);            
        }
        
        List < Id > AllBudget = new List < Id > (BudgetIds);
        AllLineItems = [Select Id,Name,X10_10_Allocation__c,Budget__c,Revenue__c,Trade__c,Trade_Option__c,Is_Parent__c,Is_sub_Parent__c,Selector__c,GP__c,In_House_Hours__c,In_House_Rate_Full__c,In_House_Rate__c,Materials__c,Other_Costs__c,Equipment__c,From_Xact__c,Bypass_Calculation__c,Actual_Costs__c,Actual_Costs_BL__c,In_House_Total__c,Subcontractor_bid__c from Budget_Line_Item__c where Budget__c =: BudgetIds];
                
        for (integer i=0; i < AllBudget.size(); i++) {
            List < Budget_Line_Item__c > BudgetWiseLineItem = new List < Budget_Line_Item__c > ();    
            for (Budget_Line_Item__c LineItem: AllLineItems) {
                if(AllBudget[i] == LineItem.Budget__c){
                BudgetWiseLineItem.add(LineItem);
                }        
            }
            if(BudgetWiseLineItem.size()>0){
                AllBudgetLIMap.put(AllBudget[i],BudgetWiseLineItem);
            }
        }
        return AllBudgetLIMap;
    } //EOD of Method to Get all Budget-LI    


//BOF Method to rolldown Parent Estimates to subparent -- By DemandBlue
    public static void RollDownCalcforEstimateItem(List<Budget_Line_Item__c> LineItems,Map<Id,Budget_Line_Item__c> OldLineItemsMap){
        Map < Id, List < Budget_Line_Item__c > > BudgetMap = BudgetLineItemFieldUpdate.GetAllBudgetLineItemMap(LineItems);
        system.debug('BLIMap:  '+BudgetMap);
        List<Budget_Line_Item__c> UpdateBLIList = new List<Budget_Line_Item__c>();
        Set<id> BypassCalculationList = new Set<id>();
        List<Budget_Line_Item__c> AllBudgetLI = new List<Budget_Line_Item__c>();    
        for (Id IterateBudgetId : BudgetMap.keySet()){ //Main Budget Map Loop
            AllBudgetLI = BudgetMap.get(IterateBudgetId);
        
        for(integer i=0;i<LineItems.size();i++) { //I Loop
            Budget_Line_Item__c oldValues = OldLineItemsMap.get(LineItems[i].ID);
            Integer [] ArrayValtoRemov = new List<Integer>();
            system.debug('Count'+AllBudgetLI.size()+' Ouside J Loop: '+AllBudgetLI);
            for(integer j=0;j<AllBudgetLI.size();j++) { //J Loop
                 //BOF of Parent Calcuation
                 Decimal ParentRevenue =0; Decimal ChildRevenue =0;
                 Budget_Line_Item__c UpdateBLIData = new Budget_Line_Item__c();
                 system.debug('J:'+j+' Count'+AllBudgetLI.size()+' Inside J Loop: '+AllBudgetLI[j].Id+' Revenue:'+AllBudgetLI[j].Revenue__c);
                if(LineItems[i].Trade__c == AllBudgetLI[j].Trade__c && LineItems[i].Id!=AllBudgetLI[j].Id && AllBudgetLI[j].Is_sub_Parent__c && LineItems[i].Is_Parent__c && !LineItems[i].Bypass_Calculation__c){
                    system.debug('Inside Else IF:'+AllBudgetLI[j].id);
                    UpdateBLIData.Id = AllBudgetLI[j].id;
                    UpdateBLIData.Bypass_Calculation__c = false;
                    //Revenue null check
                    if(LineItems[i].Revenue__c!=null){
                         ParentRevenue = LineItems[i].Revenue__c;
                    }
                    if(AllBudgetLI[j].Revenue__c!=null){
                         ChildRevenue = AllBudgetLI[j].Revenue__c;
                    }
                    
                    //Equipment for child
                    if(LineItems[i].Equipment__c!=null && (LineItems[i].Equipment__c != oldValues.Equipment__c)){
                    UpdateBLIData.Equipment__c = ((ChildRevenue / ParentRevenue)*LineItems[i].Equipment__c).setscale(2);     
                    }
                    //Material for child
                    if(LineItems[i].Materials__c!=null && (LineItems[i].Materials__c != oldValues.Materials__c)){
                    UpdateBLIData.Materials__c = ((ChildRevenue / ParentRevenue)*LineItems[i].Materials__c).setscale(2);     
                    }
                    //Sub Contact Bid
                    if(LineItems[i].Subcontractor_bid__c!=null && (LineItems[i].Subcontractor_bid__c != oldValues.Subcontractor_bid__c)){
                        UpdateBLIData.Subcontractor_bid__c = ((ChildRevenue / ParentRevenue)*LineItems[i].Subcontractor_bid__c).setscale(2);     
                    }
                    //InHouseHours for child
                    if(LineItems[i].In_House_Hours__c!=null && (LineItems[i].In_House_Hours__c != oldValues.In_House_Hours__c)){
                    UpdateBLIData.In_House_Hours__c = ((ChildRevenue / ParentRevenue)*LineItems[i].In_House_Hours__c).round();     
                    }
                    //Othercost for child
                    if(LineItems[i].Other_Costs__c!=null && (LineItems[i].Other_Costs__c != oldValues.Other_Costs__c)){
                    UpdateBLIData.Other_Costs__c = ((ChildRevenue / ParentRevenue)*LineItems[i].Other_Costs__c).setscale(2);     
                    }
                    if((LineItems[i].GP__c != oldValues.GP__c)){
                    UpdateBLIData.GP__c = LineItems[i].GP__c.setscale(2);
                    }
                    /*if((LineItems[i].In_House_Rate__c != oldValues.In_House_Rate__c)){
                        UpdateBLIData.In_House_Rate__c = LineItems[i].In_House_Rate__c.setscale(2);
                        UpdateBLIData.In_House_Rate_Full__c = LineItems[i].In_House_Rate__c;
                    }*/
                    UpdateBLIData.In_House_Rate__c = LineItems[i].In_House_Rate__c.setscale(2); // Added by Demandblue after new change
                    UpdateBLIData.In_House_Rate_Full__c = LineItems[i].In_House_Rate__c;
                    
                    
                    
                    UpdateBLIList.add(UpdateBLIData);
                    ArrayValtoRemov.add(j);
                } //EOF of Parent Calcuation
                else if (LineItems[i].Bypass_Calculation__c){
                    BypassCalculationList.add(LineItems[i].id);
                }
                system.debug('J Val: '+j+'-'+AllBudgetLI[j].Id +'-'+ AllBudgetLI[j].Is_Parent__c +'-'+ LineItems[i].Trade__c +'-'+ AllBudgetLI[j].Trade__c);
                
            } //EOF J Loop
            
            //Remove from List
            for(Integer k=0; k<ArrayValtoRemov.size();k++){
                AllBudgetLI.remove(k);
            }
            
            
        } //EOF I Loop
    } //EOF Main Budget Map Loop
        system.debug('UpdateBLIList List: '+UpdateBLIList);
        
        List<Budget_Line_Item__c> UpdatenewLineitems = new List<Budget_Line_Item__c>();
        //Upsert list.
        if(BypassCalculationList.size()>0){
            for(Id d: BypassCalculationList){
               Budget_Line_Item__c BLI = new Budget_Line_Item__c();
                BLI.Id = d;
                BLI.Bypass_Calculation__c = false;
            UpdatenewLineitems.add(BLI);
            }
        }
        if(UpdatenewLineitems.size()>0){
            upsert(UpdatenewLineitems);
        }
        
        //Upsert list.
        if(UpdateBLIList.size()>0){
            update(UpdateBLIList);
        }
    }

//BOF Method to recalculate on Delete -- By DemandBlue
    public static void RecalconDelete(List<Budget_Line_Item__c> LineItems){
        Map < Id, List < Budget_Line_Item__c > > BudgetMap = BudgetLineItemFieldUpdate.GetAllBudgetLineItemMap(LineItems); 
        List<Budget_Line_Item__c> AllBudgetLI = new List<Budget_Line_Item__c>();
        List<Budget_Line_Item__c> LineItemsNew = new List<Budget_Line_Item__c>();
        List<Budget_Line_Item__c> DeleteParentLineItem = new List<Budget_Line_Item__c>();
        for (Id IterateBudgetId : BudgetMap.keySet()){ //Main Budget Map Loop
            AllBudgetLI = BudgetMap.get(IterateBudgetId);
        
        for(integer i=0;i<LineItems.size();i++) {
            Boolean AddTradeItemOnce = true;
        for(integer j=0;j<AllBudgetLI.size();j++) {           
            if(LineItems[i].Trade__c == AllBudgetLI[j].Trade__c && (LineItems[i].Is_sub_Parent__c)&& (AllBudgetLI[j].Is_sub_Parent__c)&& (LineItems[i].id != AllBudgetLI[j].id )){
            
                if(AddTradeItemOnce){
                    System.debug('Inside true');
                    LineItemsNew.add(AllBudgetLI[j]);
                    AddTradeItemOnce = False;
                }
            
            }
        }
            if(AddTradeItemOnce){
                System.debug('Inside false');
                for(integer j=0;j<AllBudgetLI.size();j++) {
                    if(LineItems[i].Trade__c == AllBudgetLI[j].Trade__c && (LineItems[i].Is_sub_Parent__c)&& (AllBudgetLI[j].Is_Parent__c)){
                        DeleteParentLineItem.add(AllBudgetLI[j]);
                    }
                }
            }
        }
    } //EOF Main Budget Map Loop
        System.debug('LineItemNew------>'+LineItemsNew);
        System.debug('DeleteParentLineItem------>'+DeleteParentLineItem);
        
        if(DeleteParentLineItem.size() > 0){
            Database.delete(DeleteParentLineItem);
        }
        if(LineItemsNew.size() > 0){
            BudgetLineItemFieldUpdate.CreateParentforEstimateItem(LineItemsNew,null);
        }
    }

    public static void UncheckBypass(List<Budget_Line_Item__c> LineItems,Map<Id,Budget_Line_Item__c> OldLineItemsMap){
    List<Budget_Line_Item__c> UpdatenewLineitems = new List<Budget_Line_Item__c>();
        for(Budget_Line_Item__c d: LineItems){        
        d.Bypass_Calculation__c = false;
            UpdatenewLineitems.add(d);
    }
        if(UpdatenewLineitems.size()> 0){
        update UpdatenewLineitems;
        }
    }
    // public static void UpdateBudgetGoalAmount(List<Budget_Line_Item__c> budlines)
    // {
    //     for(Budget_Line_Item__c b : budlines)
    //     {
    //         b.Budget_Goal_Amount__c = b.Budget_Goal__c;
    //         b.Allocation_Amount__c = b.Allocations__c;
    //     }
    // }
    public static void UpdateOverheadProfit(List<Budget_Line_Item__c> budlines, Map<Id,Budget_Line_Item__c> oldBudLines)
    {
        //Updating Budget Goal Amount and Allocation AMount for the budget line item, was a workflow rule, now it is before update/insert
        if(Trigger.isDelete && budlines.size() < 2)
        {
  
            Budget__c bud = [SELECT Id, Allocation_Percentage__c, Overhead__c, Profit__c, Budget_lineItem_Status__c,
            (SELECT Id, Revenue__c,Selector__c, X10_10_Allocation__c, Allocation_Percentage__c,DonotDelete__c FROM Budget_Line_Items__r)
            FROM Budget__c
            WHERE Id =:budlines[0].Budget__c];
            if(bud.Budget_LineItem_Status__c == null)
            {
                bud.Overhead__c = 0;
                bud.Profit__c = 0;
                for(Budget_Line_Item__c b :  bud.Budget_Line_Items__r)
                {
                    if(b.X10_10_Allocation__c == true && b.Revenue__c != null && b.Revenue__c != 0 && b.DonotDelete__c == false)
                    {
                        bud.Overhead__c += b.Revenue__c * bud.Allocation_Percentage__c;
                        bud.Profit__c += b.Revenue__c * bud.Allocation_Percentage__c;
                        system.debug('Overhead is ' + bud.Overhead__c + '  Profit ' + bud.Profit__c);
                    }    
                }
                update bud;
            }
        }
        if(Trigger.isInsert && budlines.size() < 2)
        {
            Budget__c bud = [SELECT Id, Allocation_Percentage__c, Overhead__c, Profit__c, Budget_lineItem_Status__c,
            (SELECT Id, Revenue__c,Selector__c, X10_10_Allocation__c, Allocation_Percentage__c,DonotDelete__c FROM Budget_Line_Items__r)
            FROM Budget__c
            WHERE Id =:budlines[0].Budget__c];
            // List<Budget_Line_Item__c> budLineItems = [SELECT Id, Revenue__c,Selector__c, X10_10_Allocation__c, Allocation_Percentage__c
            // FROM Budget_Line_Item__c
            // WHERE Budget__c =: budlines[0].Budget__c];
            if(bud.Budget_LineItem_Status__c == null)
            {
                bud.Overhead__c = 0;
                bud.Profit__c = 0;
                for(Budget_Line_Item__c b : bud.Budget_Line_Items__r)
                {
                    if(b.X10_10_Allocation__c == true && b.Revenue__c != null && b.Revenue__c != 0 && b.DonotDelete__c == false)
                    {
                        bud.Overhead__c += b.Revenue__c * bud.Allocation_Percentage__c;
                        bud.Profit__c += b.Revenue__c * bud.Allocation_Percentage__c;
                        system.debug('Overhead is ' + bud.Overhead__c + '  Profit ' + bud.Profit__c);
                    }    
                }
                update bud;
            }

        }    
    }
    

}