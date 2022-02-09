package com.nicico.training.iservice;
/* com.nicico.training.iservice
@Author:Mehran Golrokhi
*/

import com.fasterxml.jackson.core.JsonProcessingException;
import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.dto.QuestionBankDTO;
import com.nicico.training.dto.SubcategoryDTO;
import com.nicico.training.model.QuestionBank;
import com.nicico.training.model.Teacher;
import org.springframework.data.domain.Page;
import org.springframework.http.ResponseEntity;
import response.question.dto.ElsQuestionBankDto;

import java.util.List;


public interface IQuestionBankService {

    boolean isExist(Long id);

    QuestionBank getById(Long Id);

    QuestionBankDTO.FullInfo get(Long Id);

    SearchDTO.SearchRs<QuestionBankDTO.Info> search(SearchDTO.SearchRq request) throws NoSuchFieldException, IllegalAccessException;
    SearchDTO.SearchRs<QuestionBankDTO.IdClass> searchId(SearchDTO.SearchRq request) throws NoSuchFieldException, IllegalAccessException;

    QuestionBankDTO.Info create(QuestionBankDTO.Create request);

    QuestionBankDTO.Info update(Long id, QuestionBankDTO.Update request);

    void delete(Long id);

    Page<QuestionBank> findAll(Integer page, Integer size);


    Page<QuestionBank> getQuestionsByCategoryAndSubCategory(Teacher teacher,Integer page ,Integer size);





}
