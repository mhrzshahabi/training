package com.nicico.training.model;

import lombok.*;
import lombok.experimental.Accessors;

import javax.persistence.*;
import javax.validation.constraints.NotNull;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Accessors(chain = true)
@EqualsAndHashCode(of = {"id"}, callSuper = false)
@Entity
@Table(name = "tbl_Class_Check_List")
public class ClassCheckList extends Auditable {
    @Id
    @GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "Class_Check_List_seq")
    @SequenceGenerator(name = "Class_Check_List_seq", sequenceName = "seq_Class_Check_List_id", allocationSize = 1)
    @Column(name = "id", precision = 10)
    private Long id;


    @Column(name = "b_enabled")
    private Boolean enableStatus;

    @Column(name = "c_description")
    private String description;


    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "f_check_list_item_id", foreignKey = @ForeignKey(name = "fk_ClassCheckList2checkListItem"), insertable = false, updatable = false)
    private CheckListItem checkListItem;

    @NotNull
    @Column(name = "f_check_list_item_id")
    private Long checkListItemId;


    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "f_tclass_id", foreignKey = @ForeignKey(name = "fk_ClassCheckList2tclass"), insertable = false, updatable = false)
    private Tclass tclass;

    @NotNull
    @Column(name = "f_tclass_id")
    private Long tclassId;
}
