package com.nicico.training.service;

import com.nicico.training.iservice.IQuestionProtocolService;
import com.nicico.training.iservice.ITestQuestionService;
import com.nicico.training.model.QuestionProtocol;
import com.nicico.training.model.TestQuestion;
import com.nicico.training.repository.TestQuestionProtocolDAO;
import dto.exam.ImportedQuestionProtocol;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Optional;

@RequiredArgsConstructor
@Service
public class QuestionProtocolService implements IQuestionProtocolService {

      private final TestQuestionProtocolDAO testQuestionProtocolDAO;
      private final ITestQuestionService testQuestionService;


    @Transactional
    @Override
    public  void saveQuestionProtocol(Long sourceExamId, List<ImportedQuestionProtocol> protocols) {
        List<QuestionProtocol> questionProtocols=findAllByExamId(sourceExamId);
        for (QuestionProtocol questionProtocol:questionProtocols){
            testQuestionProtocolDAO.delete(questionProtocol);
        }
        TestQuestion testQuestion=testQuestionService.findById(sourceExamId);

        for (ImportedQuestionProtocol protocol:protocols){
            QuestionProtocol questionProtocol=new QuestionProtocol();
            questionProtocol.setCorrectAnswerTitle(protocol.getCorrectAnswerTitle());
            questionProtocol.setExam(testQuestion);
            questionProtocol.setExamId(sourceExamId);
            questionProtocol.setQuestionId(protocol.getQuestion().getId());
            questionProtocol.setTime(protocol.getTime());
            questionProtocol.setQuestionMark( protocol.getMark().floatValue() );
            testQuestionProtocolDAO.save(questionProtocol);
         }
    }

    @Override
    public List<QuestionProtocol> findAllByExamId(Long id) {
        return testQuestionProtocolDAO.findAllByExamId(id);
    }

    @Override
    public Optional<QuestionProtocol> findOneByExamIdAndQuestionId(Long id, Long questionId) {
        return testQuestionProtocolDAO.findFirstByQuestionIdAndExamId(questionId,id);
    }

    @Override
    public List<QuestionProtocol> findAllByQuestionIds(List<Long> questionIds) {
        return testQuestionProtocolDAO.findByQuestionIds(questionIds);
    }

    @Transactional
    @Override
    public List<QuestionProtocol> saveAll(List<QuestionProtocol> questionProtocols) {
        return testQuestionProtocolDAO.saveAll(questionProtocols);
    }
}
