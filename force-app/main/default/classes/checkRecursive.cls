/**
 * @File Name          : checkRecursive.cls
 * @Description        : 
 * @Author             : sean.gray@atirestoration.com
 * @Group              : 
 * @Last Modified By   : sean.gray@atirestoration.com
 * @Last Modified On   : 2/3/2020, 8:20:18 AM
 * @Modification Log   : 
 * Ver       Date            Author      		    Modification
 * 1.0    2/3/2020   sean.gray@atirestoration.com     Initial Version
**/
public Class checkRecursive{
    @testVisible
    private static boolean run = true;
    public static boolean runOnce(){
        if(run){
         run=false;
         return true;
        }else{
            return run;
        }
    }
    // these variables control execution of batch from trigger when updating via batch
    public static boolean control_CustomBatch = true;
    public static boolean runTrigger = true;
}