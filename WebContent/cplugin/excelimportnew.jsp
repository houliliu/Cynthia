<%@page import="com.sogou.qadev.service.cynthia.util.ConfigUtil"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<meta name="Description" content="Cynthia项目缺陷管理系统，拥有表单流程化设计，可视化拖动布局等功能，提供项目管理，缺陷管理，，统计，查询等服务，是您项目上的好帮手！">
	<meta name="Keywords" content="Cynthia,BUG管理,项目管理 ,缺陷管理,任务管理,BUG,缺陷,开源">
	<link href="../lib/bootstrap2/css/bootstrap.min.css" rel="stylesheet" type="text/css">
	<link href="../lib/g_bootstrap/css/google-bootstrap.css" rel="stylesheet" type="text/css">
	<link href="../css/top.css" rel="stylesheet" type="text/css">
	<link href='../lib/select2/select2.css' rel="stylesheet" style="text/css"/>
		
	<script type="text/javascript" src="../lib/jquery/jquery-1.9.3.min.js"></script>
	<script type="text/javascript" src='../lib/bootstrap2/js/bootstrap.cynthia.min.js'></script>
	<script type="text/javascript" src="../js/util.js"></script>
	<script type="text/javascript" src="../lib/select2/select2.js"></script>
	<script type="text/javascript" src="../lib/fileUpload/ajaxfileupload.js"></script>
	
	<script type="text/javascript">
	
		$(function(){
			initAllTemplate();
		});
		
		function submitForm()
		{
			if($("#allTemplate").val() === "")
			{
				alert("提交失败,请选择表单!");
				return;
			}
			
			$("#excelbutton").attr("disabled", true);
		    // 利用ajaxFileUpload js 插件上传文件
		    $.ajaxFileUpload({url: base_url + "excelImportNew.do",
		    	secureuri:false,
		        fileElementId:"excel_file",
		        dataType:"json",
		        type:'POST',
		        async:false,
		        data:{sheetName:$("#excel_sheet_name").val(),templateIdStr:$("#allTemplate").val()},
		        success:function (data , status) {
		        	isImport(data.successNum,data.failNum);
		        },
		        error:function (data, status, e) {
		            alert("文件录入失败!");
		        }
		    });
		    
		    $("#excel_sheet_name").val('') ;
		}
		
		function initAllTemplate()
		{
			var gridHtml = "";
			gridHtml += "<option value= selected>--请选择导入表单--</option>";
			$.ajax({
				url: base_url + 'template/getAllTemplates.do',
				dataType:'json',
				async:false,
				success:function(data){
					for(var i in data){
						gridHtml += "<option value=" + data[i].first + ">" + data[i].second + "</option>";
					}
				},
				error:function(data){
					alert("server error!");
				}
			});
			$("#allTemplate").html(gridHtml);
			enableSelectSearch();
		}
		
		function isImport(successNum,failNum)
		{
			if(successNum != null && failNum != null){
				if(failNum == 0 ){
					if(successNum>0)
						alert("全部导入成功");
					else
						alert("全部导入失败，请查看邮件中详细信息!");
				}else{
					var all = successNum + failNum;
					if(successNum == 0) {
						alert("本次数据导入失败,共需导入:"+all+"条,失败:"+failNum+"条.");
					}else{
						alert("本次数据导入部分成功,共需导入:"+all+"条,失败:"+failNum+"条.");
					}
				}
			}
			$("#excelbutton").removeAttr("disabled");
		}
		
		function enableSearchSelect(){
			$("select").each(function(idx,select){
				if(!($(select).hasClass("multiLine")||$(select).hasClass('noSearch')))
				{
					$(select).select2();
				}
			});
		}
		
	</script>
	<title>Excel导入插件</title>
</head>
<body>
	<div id ="header-nav"></div>
	<div id="main" style="margin-top:50px;">
		<div id="shortmenu">
			<ul>
			</ul>
		</div>
		<div id="content">
			<div id="box">
					<table class="table table-striped table-bordered table-hover table-condensed" cellpadding="0" cellspacing="0">
	    					<tr>
	     						<td style="width: 200px;">
	     							<select style="margin-bottom:0px;width:180px;" class="select2" id="allTemplate" name="templateIdStr"></select>
	     						</td>
	        					<td colspan="3">
									<input type="file" id="excel_file" style="height:20px;" name="excelfile">
									<input type="text" id="excel_sheet_name" placeholder="sheet名字" style="margin-left:-100px;height:20px;margin-bottom:0px" name="sheetName">
	        					</td>
	   		 				</tr>
	   		 				<tr>
	   		 					<td colspan="2" align="center" valign="middle">
	   		 						<input type="button" id = "excelbutton" onclick="submitForm();" class="btn btn-danger" value="提交" />
	   		 					</td>
	   		 				</tr>
	   		 				<tr>
	     						<td colspan="2">
	     							<p style="color:red">说明：</p>
	     							<p>1：可选择输入excel中sheet名字,不填默认为sheet1;</p>
	     							<p>2：excel中列头至少包括如下字段：<b>[标题，正文，指派人，状态]</b>。指派人为邮箱名;</p>
	     							<p>3：对于表单中其它字段excel列头对应字段名;</p>
	     							<p>4：对于单选数据，excel中数据应为选项中文名;</p>
	     							<p>5：可支持07，03版本excel;</p>
	     							<p>6：导入成功与否信息会以邮箱形式给出;</p>
	     							<p>示例:</p>
	     							<img src="../images/excelimport.jpg"/>
	     						</td>
	   		 				</tr>
					</table>
			</div>
		</div>
	</div>
	
</body>
</html>