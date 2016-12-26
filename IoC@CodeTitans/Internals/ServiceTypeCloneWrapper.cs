#region License
/*
    Copyright (c) 2010, Paweł Hofman (CodeTitans)
    All Rights Reserved.

    Licensed under the Apache License version 2.0.
    For more information please visit:

    http://codetitans.codeplex.com/license
        or
    http://www.apache.org/licenses/


    For latest source code, documentation, samples
    and more information please visit:

    http://codetitans.codeplex.com/
*/
#endregion

using System;
using System.Reflection;

namespace CodeTitans.Services.Internals
{
    /// <summary>
    /// Wrapper for a service class that creates new object instance
    /// each time the service is requested.
    /// </summary>
    internal class ServiceTypeCloneWrapper : ServiceObjectWrapper
    {
        /// <summary>
        /// Init constructor.
        /// </summary>
        public ServiceTypeCloneWrapper(IServiceProviderEx provider, Type serviceType, object[] serviceConstructorArgs)
            : base(provider)
        {
            if (serviceType == null)
                throw new ArgumentNullException("serviceType");

            ServiceType = serviceType;
            ServiceArgs = serviceConstructorArgs != null && serviceConstructorArgs.Length > 0 ? serviceConstructorArgs : null;
        }

        #region Properties

        /// <summary>
        /// Gets the type of the service object.
        /// </summary>
        protected Type ServiceType
        { get; private set; }

        /// <summary>
        /// Gets the constructor arguments for a service object.
        /// </summary>
        protected object[] ServiceArgs
        { get; private set; }

        #endregion

        /// <summary>
        /// Gets or creates an instance of a service object.
        /// </summary>
        public override object GetService(object requestedServiceName)
        {
            return PrivateCreation(Provider, ServiceType, ServiceArgs);
        }

        /// <summary>
        /// Creates a new instance of the service object, if possible.
        /// </summary>
        internal static object Create(IServiceProviderEx provider, Type serviceType, object[] serviceArgs)
        {
            if (serviceType == null)
                throw new ArgumentNullException("serviceType");

            if (serviceType.IsAbstract || serviceType.IsInterface)
                return null;

            return PrivateCreation(provider, serviceType, serviceArgs);
        }

        private static object PrivateCreation(IServiceProviderEx provider, Type serviceType, object[] serviceArgs)
        {
            // create new instance of the service:
            var service = Activator.CreateInstance(serviceType);

            if (service == null)
                throw new ServiceCreationException(serviceType);

            IServiceSite site = service as IServiceSite;

            // update the reference to the service provider:
            if (site != null)
            {
                // call this function in place of constructor:
                site.SetSiteArguments(serviceArgs);
            }

            return service;
        }
    }
}
