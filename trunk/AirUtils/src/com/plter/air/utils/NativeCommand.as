package com.plter.air.utils
{
	import flash.desktop.NativeProcess;
	import flash.desktop.NativeProcessStartupInfo;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.NativeProcessExitEvent;
	import flash.events.ProgressEvent;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	
	/**
	 * 表示 NativeProcess 已关闭其错误流。
	 */
	[Event(name="standardErrorClose", type="flash.events.Event")]
	
	/**
	 * 指出 NativeProcess 对象已通过调用 closeInput() 方法关闭其输入流。
	 */
	[Event(name="standarInputClose", type="flash.events.Event")]
	
	/**
	 * 表示 NativeProcess 已关闭其输出流。
	 */
	[Event(name="standardOutputClose", type="flash.events.Event")]
	
	/**
	 * 表示从标准错误 (stderror) 流进行读取已失败。
	 */
	[Event(name="standardErrorIoError", type="flash.events.IOErrorEvent")]
	
	/**
	 * 表示写入标准输入 (stdin) 流已失败。
	 */
	[Event(name="standardInputIoError", type="flash.events.IOErrorEvent")]
	
	/**
	 * 表示从 stdout 流进行读取已失败。
	 */
	[Event(name="standardOutputIoError", type="flash.events.IOErrorEvent")]
	
	/**
	 * 表示本机进程已退出。
	 */
	[Event(name="exit", type="flash.events.NativeProcessExitEvent")]
	
	/**
	 * 表示标准错误 (stderror) 流上存在本机进程可以读取的数据。
	 */
	[Event(name="standardErrorData", type="flash.events.ProgressEvent")]
	
	/**
	 * 表示 NativeProcess 已经向子进程的输入流写入数据。
	 */
	[Event(name="standardInputProcess", type="flash.events.ProgressEvent")]
	
	/**
	 * 表示输出流上存在本机进程可以读取的数据。
	 */
	[Event(name="standardOutputData", type="flash.events.ProgressEvent")]
	
	
	/**
	 * 此类对本机命令程序进行封装，你可以通过runCmd方法来隐藏执行一条系统命令
	 * @author plter.com
	 */	
	public class NativeCommand extends EventDispatcher
	{
		
		[Embed(source="HideRun.exe",mimeType="application/octet-stream")]
		protected static const HideRunExeFile:Class;
		
		
		public function NativeCommand()
		{
			process.addEventListener(Event.STANDARD_ERROR_CLOSE,process_standardErrorCloseHandler);
			process.addEventListener(Event.STANDARD_INPUT_CLOSE,process_standarInputCloseHandler);
			process.addEventListener(Event.STANDARD_OUTPUT_CLOSE,process_standardOutputCloseHandler);
			process.addEventListener(IOErrorEvent.STANDARD_ERROR_IO_ERROR,process_standardErrorIoErrorHandler);
			process.addEventListener(IOErrorEvent.STANDARD_INPUT_IO_ERROR,process_standardInputIoErrorHandler);
			process.addEventListener(IOErrorEvent.STANDARD_OUTPUT_IO_ERROR,process_standardOutputIoErrorHandler);
			process.addEventListener(NativeProcessExitEvent.EXIT,process_exitHandler);
			process.addEventListener(ProgressEvent.STANDARD_ERROR_DATA,process_standardErrorDataHandler);
			process.addEventListener(ProgressEvent.STANDARD_INPUT_PROGRESS,process_standardInputProcessHandler);
			process.addEventListener(ProgressEvent.STANDARD_OUTPUT_DATA,process_standardOutputDataHandler);
		}
		
		private var _process:NativeProcess;
		
		/**
		 * 取得此命令所关联的本机进程对象
		 */
		public function get process():NativeProcess
		{
			if(_process==null){
				_process=new NativeProcess;
			}
			return _process;
		}
		
		/**
		 * 启动一个可执行文件，并侦听文件的状态
		 * @param file	可执行文件 
		 * @param args	参数列表
		 */		
		public function exec(file:File,args:Vector.<String>=null):void{
			if(args==null){
				args=new Vector.<String>;
			}
			
			var info:NativeProcessStartupInfo=new NativeProcessStartupInfo;
			info.executable=file;
			info.arguments=args;
			process.start(info);
		}
		
		
		/**
		 * 执行一条系统命令
		 * @param args	参数列表
		 */
		public function runCmd(args:Vector.<String>):void{
			exec(hideRunFile,args);
		}
		
		private var _hideRunFile:File;
		
		private function get hideRunFile():File{
			if(_hideRunFile==null||!_hideRunFile.exists){
				_hideRunFile=File.applicationStorageDirectory.resolvePath("HideRun");
				
				var stream:FileStream=new FileStream;
				stream.open(_hideRunFile,FileMode.WRITE);
				stream.writeBytes(new HideRunExeFile);
				stream.close();
			}
			
			return _hideRunFile;
		}
		
		/**-------------------------------------handlers----------------------------------------------*/
		
		/**
		 * 表示 NativeProcess 已关闭其错误流。
		 */
		protected function process_standardErrorCloseHandler(event:Event):void{
			dispatchEvent(event);
		}
		
		/**
		 * 指出 NativeProcess 对象已通过调用 closeInput() 方法关闭其输入流。
		 */
		protected function process_standarInputCloseHandler(event:Event):void{
			dispatchEvent(event);
		}
		
		
		/**
		 * 表示 NativeProcess 已关闭其输出流。
		 */
		protected function process_standardOutputCloseHandler(event:Event):void{
			dispatchEvent(event);
		}
		
		/**
		 * 表示从标准错误 (stderror) 流进行读取已失败。
		 */
		protected function process_standardErrorIoErrorHandler(event:IOErrorEvent):void{
			dispatchEvent(event);
		}
		
		/**
		 * 表示写入标准输入 (stdin) 流已失败。
		 */
		protected function process_standardInputIoErrorHandler(event:IOErrorEvent):void{
			dispatchEvent(event);
		}
		
		/**
		 * 表示从 stdout 流进行读取已失败。
		 */
		protected function process_standardOutputIoErrorHandler(event:IOErrorEvent):void{
			dispatchEvent(event);
		}
		
		/**
		 * 表示本机进程已退出
		 */
		protected function process_exitHandler(event:NativeProcessExitEvent):void{
			dispatchEvent(event);
		}
		
		/**
		 * 表示标准错误 (stderror) 流上存在本机进程可以读取的数据。
		 */
		protected function process_standardErrorDataHandler(event:ProgressEvent):void{
			dispatchEvent(event);
		}
		
		/**
		 * 表示 NativeProcess 已经向子进程的输入流写入数据。
		 */
		protected function process_standardInputProcessHandler(event:ProgressEvent):void{
			dispatchEvent(event);
		}
		
		/**
		 * 表示 NativeProcess 表示输出流上存在本机进程可以读取的数据。
		 */
		protected function process_standardOutputDataHandler(event:ProgressEvent):void{
			dispatchEvent(event);
		}
	}
}