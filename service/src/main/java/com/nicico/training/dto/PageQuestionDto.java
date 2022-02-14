package com.nicico.training.dto;

import com.nicico.training.model.QuestionBank;
import lombok.Getter;
import lombok.Setter;
import org.springframework.data.domain.Page;

@Getter
@Setter
public class PageQuestionDto {
   private Page<QuestionBank> pageQuestion;
    private  Long totalSpecCount;
}
