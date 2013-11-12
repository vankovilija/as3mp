//------------------------------------------------------------------------------
//  Copyright (c) 2009-2013 the original author or authors. All Rights Reserved.
//
//  NOTICE: You are permitted to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//------------------------------------------------------------------------------

package robotlegs.bender.extensions.messageControl
{
    import robotlegs.bender.extensions.messageControl.api.IMessageControl;
    import robotlegs.bender.extensions.messageControl.impl.MessageControl;
	import robotlegs.bender.framework.api.IContext;
	import robotlegs.bender.framework.api.IExtension;
	import robotlegs.bender.framework.api.IInjector;

	/**
	 * This extension installs a shared IMessageControl into the context
	 */
	public class MessageControlExtension implements IExtension
	{

		/*============================================================================*/
		/* Private Properties                                                         */
		/*============================================================================*/

		private var _injector:IInjector;

		private var _messageControl:MessageControl;

		/*============================================================================*/
		/* Public Functions                                                           */
		/*============================================================================*/

		/**
		 * @inheritDoc
		 */
		public function extend(context:IContext):void
		{
			context.afterInitializing(afterInitializing)
				.beforeDestroying(beforeDestroying)
				.whenDestroying(whenDestroying);
			_injector = context.injector;
			_injector.map(IMessageControl).toSingleton(MessageControl);
		}

		/*============================================================================*/
		/* Private Functions                                                          */
		/*============================================================================*/

		private function afterInitializing():void
		{
			_messageControl = _injector.getInstance(IMessageControl);
			_injector.injectInto(_messageControl);
		}

		private function beforeDestroying():void
		{
//			_messageControl.unmediateAll();
//			if (_injector.satisfiesDirectly(IViewManager))
//			{
//				_viewManager = _injector.getInstance(IViewManager);
//				_viewManager.removeViewHandler(_messageControl);
//			}
		}

		private function whenDestroying():void
		{
			if (_injector.satisfiesDirectly(IMessageControl))
			{
				_injector.unmap(IMessageControl);
			}
		}
	}
}
