package com.groupcotton.dao
{
	import flash.data.SQLStatement;
	
	import app.drawlots.model.node;
	
	import mx.collections.ArrayCollection;
	
	public class BaseDAO
	{
		public function getItem(id:int):node
		{
			var sql:String = "SELECT id, time, content FROM drawlots WHERE id=?";
			var stmt:SQLStatement = new SQLStatement();
			stmt.sqlConnection = DatabaseHelper.sqlConnection;
			stmt.text = sql;
			stmt.parameters[0] = id;
			stmt.execute();
			var result:Array = stmt.getResult().data;
			if (result && result.length == 1)
				return processRow(result[0]);
			else
				return null;
				
		}

		

		public function findByName(searchKey:String):ArrayCollection
		{
			
			
			 var sql:String = "SELECT * FROM drawlots WHERE content  LIKE '%"+searchKey+"%' ORDER BY id desc ";
			 var stmt:SQLStatement = new SQLStatement();
			 stmt.sqlConnection = DatabaseHelper.sqlConnection;
			 stmt.text = sql;
//			 stmt.parameters[0] = searchKey;
			 stmt.execute();
			 var result:Array = stmt.getResult().data;
			 if (result)
			 {
				 var list:ArrayCollection = new ArrayCollection();
				 for (var i:int=0; i<result.length; i++)
				 {
					 list.addItem(processRow(result[i]));	
				 }
				 return list;
			 }
			 else
			 {
				 return null;
			 }
		}
		
		public function getMaxID():int{
			var sql:String = "SELECT max(id) maxid FROM drawlots ";
			var stmt:SQLStatement = new SQLStatement();
			stmt.sqlConnection = DatabaseHelper.sqlConnection;
			stmt.text = sql;
			
			stmt.execute();
			var result:Array = stmt.getResult().data;
			
			return result[0].maxid;
		}

		public function create(_note:node):void
		{
			trace(_note.content);
			
			var sql:String = 
				"INSERT INTO drawlots (id, time, content) " +
				"VALUES (?,?,?)";
			var stmt:SQLStatement = new SQLStatement();
			stmt.sqlConnection = DatabaseHelper.sqlConnection;
			stmt.text = sql;
			stmt.parameters[0] = _note.id;
			stmt.parameters[1] = _note.time;
			stmt.parameters[2] = _note.content;
			
			stmt.execute();
			_note.loaded = true;
		}
		
		public function update(_note:node):void{
			
			var sql:String = 
				"UPDATE drawlots set time=? , content=? where id=? ";
			var stmt:SQLStatement = new SQLStatement();
			stmt.sqlConnection = DatabaseHelper.sqlConnection;
			stmt.text = sql;
			stmt.parameters[0] = _note.time;
			stmt.parameters[1] = _note.content;
			stmt.parameters[2] = _note.id;
			
			stmt.execute();
			_note.loaded = true;
		}
		
		public function deleteNote(id:int):void{
			var sql:String = 
				"delete from drawlots where id=?";
			var stmt:SQLStatement = new SQLStatement();
			stmt.sqlConnection = DatabaseHelper.sqlConnection;
			stmt.text = sql;
			stmt.parameters[0] = id;
			stmt.execute();
		}
		
		protected function processRow(o:Object):node
		{
			var _note:node = new node();
			_note.id = o.id;
			_note.time = o.time == null ? "" : o.time;
			_note.content = o.content == null ? "" : o.content;
			
			_note.loaded = true;
			return _note;
		}

		
	}
}