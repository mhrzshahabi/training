package com.nicico.training.dto;

import com.nicico.training.model.QuestionBank;
import lombok.Getter;
import lombok.Setter;
import org.springframework.data.domain.Page;

import java.util.List;

@Getter
@Setter
public class PageQuestionDto {
   private List<QuestionBank> pageQuestion;
    private  Long totalSpecCount;
}
