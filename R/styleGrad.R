styleGrad <-
function(prop, breaks, right=TRUE, out=0, style.par="col", style.val, leg, ...) {
	breaks <- rev(breaks)
	sp <- c("col", "rad")
	style.par <- sp[pmatch(style.par, sp)]
	style.val <- rev(style.val)
	if(style.par=="col") for(i in 1:length(style.val)) style.val[i] <- getHex(style.val[i])
	if(!missing(leg)) leg <- gsub("\n", "<br>", leg)
	
	if(out==0 && length(breaks)!=(length(style.val)+1)) stop("Length of 'style.val' (", length(style.val), ") does not match the number of classes (", length(breaks)-1,")")
	if((out==1 || out==2) && length(breaks)!=length(style.val)) stop("Length of 'style.val' (", length(style.val), ") does not match the number of classes (", length(breaks),")")
	if(out==3 && length(breaks)!=(length(style.val)-1)) stop("Length of 'style.val' (", length(style.val), ") does not match the number of classes (", length(breaks)+1,")")
	
	if(right) op <- ">= " else op <- "> "
	
	stl.val <- style.val
	if(style.par=="col") stl.val <- paste0("\"", style.val, "\"")
	if(style.par=="col") def <- "\"#808080\""
	else if(style.par=="rad") def <- "0"
	if(out==0) { # left and right closed
		grad.style <- paste0("return x ", op, breaks[1], " ? ", def, " :")
		for(n in 2:length(breaks)) grad.style <- append(grad.style, paste0("       x ", op, breaks[n], " ? ", stl.val[n-1], " :"))
		grad.style <- append(grad.style, paste("       ", def, ";", sep=""))
	} else if(out==1) { # left closed right open
		grad.style <- paste("return x ", op, breaks[1], " ? ", stl.val[1], " :", sep="")
		for(n in 2:length(breaks)) grad.style <- append(grad.style, paste0("       x ", op, breaks[n], " ? ", stl.val[n], " :"))
		grad.style <- append(grad.style, paste0("       ", def, ";"))
	} else if(out==2) {
		grad.style <- paste0("return x ", op, breaks[1], " ? ", def, " :")
		for(n in 2:length(breaks)) grad.style <- append(grad.style, paste0("       x ", op, breaks[n], " ? ", stl.val[n-1], " :"))
		grad.style <- append(grad.style, paste("       ", stl.val[n], ";", sep=""))
	} else { # left and right open
		grad.style <- paste("return x ", op, breaks[1], " ? ", stl.val[1], " :", sep="")
		for(n in 2:length(breaks)) grad.style <- append(grad.style, paste0("       x ", op, breaks[n], " ? ", stl.val[n], " :"))
		grad.style <- append(grad.style, paste0("       ", stl.val[n+1], ";"))
	}
	
	s <- list(...)
	single.style <- NULL
	if(length(s)>0) {
		if(any(names(s)=="col")) {
			if(is.na(s$col)) single.style <- append(single.style, "\"stroke\": false")
			else single.style <- append(single.style, paste0("\"color\": \"", getHex(s$col), "\""))
		} else if(style.par=="rad") single.style <- append(single.style, "\"color\": \"#0033ff\"")
		if(any(names(s)=="lwd")) single.style <- append(single.style, paste("\"weight\":", s$lwd))
		else if(style.par=="rad") single.style <- append(single.style, "\"weight\": 2")
		if(any(names(s)=="alpha")) single.style <- append(single.style, paste("\"opacity\":", s$alpha))
		else if(style.par=="rad") single.style <- append(single.style, "\"opacity\": 0.5")
		if(any(names(s)=="fill")) {
			if(is.na(s$fill)) single.style <- append(single.style, "\"fill\": false")
			else single.style <- append(single.style, paste0("\"fillColor\": \"", getHex(s$fill), "\""))
		} else if(style.par=="rad") single.style <- append(single.style, "\"fillColor\": \"#0033ff\"")
		if(any(names(s)=="fill.alpha")) single.style <- append(single.style, paste("\"fillOpacity\":", s$fill.alpha))
		else single.style <- append(single.style, "\"fillOpacity\": 0.5")
		if(any(names(s)=="rad")) single.style <- append(single.style, paste("\"radius\":", s$rad))
	} else {
		single.style <- append(single.style, "\"fillOpacity\": 0.5")
		if(style.par=="rad") {
			single.style <- append(single.style, "\"color\": \"#0033ff\"")
			single.style <- append(single.style, "\"weight\": 2")
			single.style <- append(single.style, "\"fillColor\": \"#0033ff\"")
			single.style <- append(single.style, "\"opacity\": 0.5")
		}
	}
	
	grad.style <- list(style=grad.style, add=single.style)
	attr(grad.style, "style.type") <- "graduated"
	attr(grad.style, "property") <- prop
	attr(grad.style, "breaks") <- rev(breaks)
	attr(grad.style, "right") <- right
	attr(grad.style, "out") <- out
	attr(grad.style, "style.par") <- style.par
	if(!missing(leg)) attr(grad.style, "leg") <- leg
	class(grad.style) <- c("leafletr.style", "graduated.style")
	return(grad.style)
}
