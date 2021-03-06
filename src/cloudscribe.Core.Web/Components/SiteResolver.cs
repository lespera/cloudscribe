﻿// Copyright (c) Source Tree Solutions, LLC. All rights reserved.
// Licensed under the Apache License, Version 2.0. See License.txt in the project root for license information.
// Author:              Joe Audette
// Created:             2016-02-04
// Last Modified:       2016-02-04
// 

//  2016-02-04 found this blog post by Ben Foster
//  http://benfoster.io/blog/asp-net-5-multitenancy
//  and the related project https://github.com/saaskit/saaskit
//  I like his approach better than mine though they are similar
//  his seems a little cleaner so I'm adopting it here to replace my previous pattern
//  actual resolution process is the same as before

using cloudscribe.Core.Models;
using Microsoft.AspNet.Http;
using Microsoft.Extensions.OptionsModel;
using SaasKit.Multitenancy;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading;
using System.Threading.Tasks;



namespace cloudscribe.Core.Web.Components
{
    public class SiteResolver : ITenantResolver<SiteSettings>
    {
        public SiteResolver(
            ISiteRepository siteRepository,
            SiteDataProtector dataProtector,
            IOptions<MultiTenantOptions> multiTenantOptions)
        {
            siteRepo = siteRepository;
            this.multiTenantOptions = multiTenantOptions.Value;
            this.dataProtector = dataProtector;
        }

        private MultiTenantOptions multiTenantOptions;
        private ISiteRepository siteRepo;
        private SiteDataProtector dataProtector;

        public Task<TenantContext<SiteSettings>> ResolveAsync(HttpContext context)
        {
            if(multiTenantOptions.Mode == MultiTenantMode.FolderName)
            {
                return ResolveByFolderAsync(context);
            }

            return ResolveByHostAsync(context);
        }

        private async Task<TenantContext<SiteSettings>> ResolveByFolderAsync(HttpContext context)
        {
            var siteFolderName = context.Request.Path.StartingSegment();
            if (siteFolderName.Length == 0) { siteFolderName = "root"; }

            TenantContext<SiteSettings> tenantContext = null;

            CancellationToken cancellationToken = context?.RequestAborted ?? CancellationToken.None;

            ISiteSettings site 
                = await siteRepo.FetchByFolderName(siteFolderName, cancellationToken);

            if (site != null)
            {
                dataProtector.UnProtect(site);

                tenantContext = new TenantContext<SiteSettings>((SiteSettings)site);
            }

            return tenantContext;

            
        }

        private async Task<TenantContext<SiteSettings>> ResolveByHostAsync(HttpContext context)
        {
            TenantContext<SiteSettings> tenantContext = null;

            CancellationToken cancellationToken = context?.RequestAborted ?? CancellationToken.None;

            ISiteSettings site
                = await siteRepo.Fetch(context.Request.Host.Value, cancellationToken);

            if (site != null)
            {
                dataProtector.UnProtect(site);

                tenantContext = new TenantContext<SiteSettings>((SiteSettings)site);
            }

            return tenantContext;
        }

    }
}
