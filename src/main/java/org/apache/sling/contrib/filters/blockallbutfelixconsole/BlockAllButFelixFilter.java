package org.apache.sling.contrib.filters.blockallbutfelixconsole;

import java.io.IOException;
import java.util.Map;

import javax.servlet.Filter;
import javax.servlet.FilterChain;
import javax.servlet.FilterConfig;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.felix.scr.annotations.Activate;
import org.apache.felix.scr.annotations.Component;
import org.apache.felix.scr.annotations.sling.SlingFilter;
import org.apache.felix.scr.annotations.sling.SlingFilterScope;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;


@SlingFilter(scope = SlingFilterScope.REQUEST, order = 0, generateComponent = false)//@Activate doesn't pick up if @SlingFilter generates Component.
@Component(immediate = false, enabled = false)
public class BlockAllButFelixFilter implements Filter {

    private static final Logger log = LoggerFactory.getLogger(BlockAllButFelixFilter.class);
    
    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
    }
    
    private long componentStarted;
    
    
    @Activate
    protected void activate(Map<String, ?> config) {
        componentStarted = System.currentTimeMillis();
        log.debug("started: " + componentStarted);
    }
    
    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain) throws IOException, ServletException {
        if (request instanceof HttpServletRequest && response instanceof HttpServletResponse) {
            final HttpServletRequest httpRequest = (HttpServletRequest) request;
            final HttpServletResponse httpResponse = (HttpServletResponse) response;
            
            if (!httpRequest.getPathInfo().startsWith("/system/console/")) {
                httpResponse.setStatus(503);
                httpResponse.setContentType("text/plain; charset=utf-8");
                httpResponse.setCharacterEncoding("utf-8");
                final double duration =  (System.currentTimeMillis() - componentStarted) / 1000.0;
                httpResponse.getWriter().format("deployment is in process for %f secs. try again a few minutes later.\n", duration);
                httpResponse.flushBuffer();
                return;
                
            }
        }

        chain.doFilter(request, response);
    }

    @Override
    public void destroy() {
    }

}
