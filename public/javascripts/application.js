var last_update = 0;

$(document).ajaxSend(function(event, request, settings) { 
	if (typeof(window._token) == "undefined") return;
	
  settings.data = settings.data || "";
  settings.data += (settings.data ? "&" : "") + "authenticity_token=" + encodeURIComponent(window._token);
});

$(document).ready(function () {
	columnsEqualHeight();
	
	var status_editor = $('#status_message');
	
	if (status_editor[0] != undefined) {
		
		var end_pos = status_editor.val().length;
		
		status_editor.bind('keyup', function () {
			$('#letters').text(500 - status_editor.val().length);
		}).autogrow({
			minHeight: 40,
			lineHeight: 12
		}).focus().keyup();
		
		status_editor[0].setSelectionRange(end_pos,end_pos);
	}
	
	$('#snippet_code').autogrow({
		minHeight: 300,
		lineHeight: 14
	}).focus();
	
	$('#new_status').submit(function () {
		var size = $('#status_message').val().length;
		
		if (size < 3 || size > 500) {
			alert('Wiadomość jest za długa(max 500 znaków) lub za krótka(min 3 znaki)!')
			return false;
		}
		
		$.ajax({
			url: $(this).attr('action'),
			type: 'POST',
			data: $(this).serialize(),
			dataType: 'script'
		});
		
		$(this)[0].reset();
		$('#letters').text('500');
		return false;
	});
	
	$('.more a').click(function () {
		var link = $(this);
		link.hide();
		$.ajax({
			url: link.attr('href'),
			type: 'GET',
			data: 'time='+$('.statusy:last').find('.time:last').attr('id').replace('date_',''),
			dataType: 'script',
			success: function () {
				link.show();
			}
		});
		
		return false;
	});
	
	var timeout = null;
	
	$('#search_tools #name').bind('keyup', function () {
		var val = $(this).val();
		var form = $(this).parents('form');
		if (timeout) clearTimeout(timeout);
		
		timeout = setTimeout(function () {
			$.getScript('/tools/search?name='+val);
		}, 500);
	});
	
	if ($('#search_form')[0] != undefined) {
		$('.sidebar ul a').optionsFor('#search_form');
		
		$('#keyword').bind('keyup', function () {
			if (timeout) clearTimeout(timeout);
			
			timeout = setTimeout(function () {
				$('#search_form').submit();
			}, 500);
		});
		
		$('#search_form').submit(function () {
			$('#keyword').addClass('loading');
			
			$.ajax({
				url: $(this).attr('action'),
				type: 'GET',
				data: $(this).serialize(),
				dataType: 'script',
				success: function () {
					$('#keyword').removeClass('loading');
				}
			});
			
			return false;
		});
	}
	
	$('#project_used_tools option').attr("selected","selected");
	$('#project_used_tools').fcbkcomplete({
		json_url: '/tools/suggest',
		firstselected: true
	});
});

function columnsEqualHeight(){
	var sidebar = $('.wrapper > .sidebar').height();
	var content = $('.wrapper > .content').height();
	
	if (sidebar != content) {
		var height = Math.max(sidebar, content);
		$('.wrapper > .sidebar').css('min-height', height+'px');
		$('.wrapper > .content').css('min-height', height+'px');
	}
	
	setTimeout(function () {
		columnsEqualHeight();
	}, 1000);
}

function getStatuses(){
	setTimeout(function () {
		$.ajax({
			url: window.location.href.replace('#', ''),
			type: 'GET',
			data: 'time='+last_update,
			dataType: 'script'
		});
	}, 10000);
}

function deleteStatus(status) {
	var self = $(status);
	
	self.parents('li').slideUp(function () {
			self.remove();
	});
	
	$.ajax({
		url: self.attr('href'),
		type: 'POST',
		data: '_method=delete',
		dataType: 'script'
	});
		
	return false;
}

function addStatus(id,html,date,date_title, top) {
	if ($('#statusy_'+date)[0] == undefined) {
		var h4 = $('<h4>'+date_title+'</h4>');
		var ul = $('<ul class="statusy" id="statusy_'+date+'"></ul>');
		if (top) {
			$('#statusy_container').prepend(ul).prepend(h4);
		}else{
			$('#statusy_container').append(h4).append(ul);
		}
	}
	
	if ($('#status_'+id)[0] == undefined) {
		if (top) {
			$('#statusy_'+date).prepend(html);
		}else{
			$('#statusy_'+date).append(html);
		}
	}
}

function flash(type, message) {
	$('body').append('<div class="'+type+'"><div>'+message+'</div></div>');
	$('.notice, .error').hover(function () {
		$(this).animate({ top: '-40px' });
	});
	setTimeout(function () {
		$('.notice, .error').animate({ top: '-40px' });
	}, 5000);
}

$.fn.extend({
	optionsFor: function(form){
		$(this).each(function () {
			var a = $(this);
			a.click(function () {
				a.parents('ul').find('li').removeClass('selected');
				a.parent('li').addClass('selected');
				
				var link = a.attr('href').split('_');
				$(link[0]).val(link[1]);
				$(form).submit();
				
				return false;
			});
		});
	}
});