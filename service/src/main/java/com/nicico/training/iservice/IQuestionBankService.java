package com.nicico.training.iservice;
/* com.nicico.training.iservice
@Author:Mehran Golrokhi
*/

import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.dto.ClassStudentDTO;
import com.nicico.training.dto.QuestionBankDTO;
import com.nicico.training.dto.TclassDTO;
import com.nicico.training.model.QuestionBank;
import com.nicico.training.model.Tclass;
import org.springframework.transaction.annotation.Transactional;

import javax.servlet.http.HttpServletResponse;
import java.util.List;
import java.util.Map;

public interface IQuestionBankService {

    boolean isExist(Long id);

    QuestionBank getById(Long Id);

    QuestionBankDTO.FullInfo get(Long Id);

    SearchDTO.SearchRs<QuestionBankDTO.Info> search(SearchDTO.SearchRq request) throws NoSuchFieldException, IllegalAccessException;

    QuestionBankDTO.Info create(QuestionBankDTO.Create request);

    QuestionBankDTO.Info update(Long id, QuestionBankDTO.Update request);

    void delete(Long id);
}
