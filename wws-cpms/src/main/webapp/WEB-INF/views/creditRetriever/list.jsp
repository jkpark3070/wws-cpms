<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
	<div style='margin:10px 0 20px 0;'>
			<span> [신용정보 검색]</span>&nbsp;&nbsp;&nbsp;
			   
	           이름 :  <input type="text" id='targetName' name="targetName"/>
	           조회번호 :  <input type="text" id='targetNum' name="targetNum"/>
	           판매점 :<span id='shopSeq2' style='font-weight: bold;font-size: 13px;font: 2px;margin:0 10px 0 10px'>${shop.shopName}</span>
	    
	            
	           <select name='telecom' id='telecom'>
		           	<option>:::통신사:::</option>
		           	<option value='skt'>SKT</option>
		           	<option value='kt'>KT</option>
		           	<option value='lgu'>LGU</option>
		           	<option value="other">기타</option>
	           </select>
	            <input type="button" value="신용조회 " id='retrieverBtn'/>
		</div>
		<table id='creditRetriverReqList'>
		
		</table>
		<div id='pager'></div>
		
	<script>
$(function(){
	
	
	
	var $credList=$('#creditRetriverReqList');
	var id = ${shop.shopSeq};
	function custDetail(value, options, rowObject){
		return '<a href="javascript:window.open()">';
	}
	
	
	
	$credList.jqGrid({
		
		url:'${HOME}/creditRetriever/list.do?id='+id,
		datatype:'json',
		mtype:'POST',
		colNames:['순번','등록일자','판매점','고객명','조회번호','조회상태','조회결과','관리','조회내용','통신사'],
		colModel:[{name:'credSeq',index:'credSeq',width:30,align:'center',key:true,hidden:true},
		          {name:'credRegDate',index:'credRegDate',width:100,align:'center'},
		          {name:'shopName',index:'shopName',width:100,align:'center'},
		          {name:'targetName',index:'targetName',width:100,align:'center'},
		          {name:'targetNum',index:'targetNum',width:100,align:'center'},
		          {name:'credStatus',index:'credStatus',width:100,align:'center',
		        	  editable:true,edittype:'text',editoptions:{size:50}
		          },
		          {name:'credResult',index:'credResult',width:100,align:'center',
		        		  editable:true,edittype:'text',editoptions:{size:50}},
		          {name:'credManage',index:'credManage',width:100,align:'center',
		        			  editable:true,edittype:'text',editoptions:{size:50}},
		          {name:'credNote',index:'credNote',width:100,align:'center',editable:true,
		        	  editoptions:{size:50}, edittype:'text'},
		          {name:'telecom',index:'telecom',width:100,align:'center'}
		        	  
		          ],
		pager:'#pager',
		pagenation:true,
		rowNum:10,
		rowList:[10,20,30],
		sortname:'credSeq',
		viewrecords:true,
		sortorder:'desc',
		emptycords:'조회요청자료가 없습니다.',
		viewrecordes:true,
		gridview:true,
		rownumbers:true,
		autoencode:true,
		loadtext: '데이터 로딩중입니다...',
		caption:'신용조회요청',
		autowidth:true,
		scrollrows : true,
		height:'auto',
		multiselect:true,
		reloadAfterSubmit:true,
		jsonReader:{
			repeattimes:false,
			 id:'credSeq' 
		},
		
	
		cellEdit:true,
		cellsubmit:'remote',
		cellurl:'${HOME}/creditRetriever/editCredStatus.do',
		 beforeSubmitCell:function(rowid,cellname,value){
			return {'credSeq':rowid,'credStatus':cellname,'value':value}
		},
		cellurl:'${HOME}/creditRetriever/editCredResult.do',
		 beforeSubmitCell:function(rowid,cellname,value){
			return {'credSeq':rowid,'credResult':cellname,'value':value}
		},
		cellurl:'${HOME}/creditRetriever/editCredManage.do',
		 beforeSubmitCell:function(rowid,cellname,value){
			return {'credSeq':rowid,'credManage':cellname,'value':value}
		},
		cellurl:'${HOME}/creditRetriever/editCredNote.do',
		 beforeSubmitCell:function(rowid,cellname,value){
			return {'credSeq':rowid,'credNote':cellname,'value':value}
		},
		afterSubmitCell:function(res){
			var aResult = $.parseJSON(res.responseText);
		
			if((aResult.msg='success')){
				userMsg = '데이터가 변경되었습니다.';
			}
			return [(aResult.msg=='success')?true:false,userMsg];
		}
		
		
		
	});
	$credList.jqGrid('navGrid','#pager'
	       		  ,{excel:false,add:false,search:true,edit:false,del:true,view:true,refresh:true}
	         	  ,{url:'${HOME}/creditRetriever/edit.do'}
	         	  ,{} // add 
	         	  ,{url: '${HOME}/creditRetriever/delete.do'}// delete
	         	  ,{}
	         	  ,{} //view
	         	  
	);
	$(function(){
		$('#retrieverBtn').click(function(){
			$.ajax({
				url:'${HOME}/creditRetriever/write.do?id='+id,
				type:'POST',
				data:{
					targetName : $('#targetName').val(),
					targetNum : $('#targetNum').val(),
					shopSeq : $('#shopSeq').val(),
					telecom : $('#telecom').val()
				},
				dataType:'json',
				success:function(data){
					if(data.status == 'success'){
						$credList.trigger('reloadGrid');
					}else{
						window.alert('Ajax 에 FAIL값이 넘어왔습니다. 검토바랍니다.');
					}
				},
				error:function(e){
					
				}
			});
	 	});
	});
	
	
	
	

});	
</script>