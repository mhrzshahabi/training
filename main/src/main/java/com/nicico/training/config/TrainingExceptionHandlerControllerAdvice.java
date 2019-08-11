package com.nicico.training.config;

import com.nicico.copper.common.AbstractExceptionHandlerControllerAdvice;
import com.nicico.copper.common.dto.ErrorResponseDTO;
import org.springframework.web.bind.annotation.ControllerAdvice;

import java.util.HashMap;
import java.util.Map;

@ControllerAdvice
public class TrainingExceptionHandlerControllerAdvice extends AbstractExceptionHandlerControllerAdvice {

	@Override
	protected Map<String, ErrorResponseDTO.ErrorFieldDTO> getUniqueConstraintErrors() {
		Map<String, ErrorResponseDTO.ErrorFieldDTO> errorCodeMap = new HashMap<>();

		return errorCodeMap;
	}
}
