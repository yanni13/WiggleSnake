//
//  AddChallengeView.swift
//  WiggleSnack
//
//  Created by 아우신얀 on 4/14/25.
//

import SwiftUI

struct AddChallengeView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.presentationMode) private var presentationMode
    @StateObject private var viewModel = AddChallengeViewModel()
    @State private var selectedCategory: Int = 0
    @State private var date: Date = Date()

    /// 카테고리 바텀시트를 보여주도록 하는 상태변수
    @State private var isActiveCategory: Bool = false
    /// datepicker을 보여주도록 하는 변수
    @State private var isActivePicker: Bool = false
    /// 시작일, 종료일 중 어느걸 선택하는지 구분하는 상태
    @State private var isPickerStartData = true
    /// 사용자가 선택했는지 여부를 추적하는 상태 변수

    
    var body: some View {
        ZStack {
            VStack(alignment: .leading) {
                Spacer().frame(height: 40)
                titleComponent()
                
                Spacer().frame(height: 33)
                
                categoryComponent()
                
                Spacer().frame(height: 25)
                
                setDateComponent()
                
                Spacer().frame(height: 33)
                
                memoComponent()
                
                Spacer()
                
                
                CustomBottomBtn(action: {
                    // 필수 입력값이 다 들어갔다면 -> 저장
                    viewModel.formValid { success in
                        if success {
                            viewModel.saveChallenge(context: viewContext)
                            self.presentationMode.wrappedValue.dismiss()
                            print("✅ [AddChallengeView] 도전일기 저장완료")
                            
                        } else {
                            viewModel.isValidForm = true
                            print("❌ [AddChallengeView] 도전일기 저장 실패")
                            print("📝 제목: \(viewModel.title)")
                            print("📄 메모: \(viewModel.memo)")
                            print("📂 카테고리: \(viewModel.category)")
                            print("📅 시작일: \(viewModel.startDate)")
                            print("📅 종료일: \(viewModel.endDate)")
                            
                        }
                        
                    }

                }, label: "확인")
                .padding(.bottom, 34)
                
                //TODO: 폼이 유효하지 않을 때 alert 혹은 팝업
//                if viewModel.isValidForm {
//
//                }
            }
            .padding(.horizontal, 20)
            .navigationTitle("도전 일기 추가하기")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(true)
            .edgesIgnoringSafeArea(.bottom)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    HStack {
                        NavigationBackBtn()
                            .padding(.leading, 5)
                            .contentShape(Rectangle())
                        
                    }.offset(x: -10)
                }
            }
            .sheet(isPresented: $isActiveCategory) {
                Spacer().frame(height: 56)
                
                CategoryListView(viewModel: viewModel, selectedIndex: $selectedCategory)
                    .presentationDetents([.large, .large])
                    .presentationDragIndicator(.visible)
                    .presentationCornerRadius(20)
            }
            .sheet(isPresented: $isActivePicker, onDismiss: {
                if isPickerStartData {
                    viewModel.startDate = date
                } else {
                    viewModel.endDate = date
                }
            }) {
                DatePicker("", selection: $date, displayedComponents: .date)
                    .presentationDetents([.medium, .medium])
                    .datePickerStyle(.graphical)
                    .edgesIgnoringSafeArea(.bottom)
                    .padding(.horizontal, 20)
                    .presentationCornerRadius(20)
                
            }
    }
    
}

    @ViewBuilder
    private func titleComponent() -> some View {
        VStack(alignment: .leading, spacing: 10) {
            InquiryText(title: "목표", isRequired: true)
            
            ZStack(alignment: .leading) {
                Rectangle()
                    .frame(maxWidth: .infinity, maxHeight: 54)
                    .foregroundColor(.gray01)
                    .cornerRadius(4)
                
                
                if viewModel.title.isEmpty {
                    Text("청소하기, 하루 5분 명상하기...")
                        .font(.H5MediumFont())
                        .foregroundColor(.gray02)
                        .padding(.leading, 17)
                }
                
                TextField("", text: $viewModel.title)
                    .offset(x: 17)
                    .onChange(of: viewModel.title) { newValue in
                        if newValue.count > 23 {
                            viewModel.title = String(newValue.prefix(23)) // 글자 수 제한
                        }
                    }
                    .font(.H5MediumFont())
                    .foregroundColor(.gray05)
            }
            
        }
    }
    
    @ViewBuilder
    private func categoryComponent() -> some View {
        let categoryValid = selectedCategory > 0 && selectedCategory < CategoryIcon.allCases.count
        HStack {
            InquiryText(title: "카테고리", isRequired: true)
            
            Spacer()
            
            Button(action: {
                isActiveCategory = true
            }, label: {
                Text(categoryValid ? CategoryIcon.allCases[selectedCategory].groupTitle : "카테고리를 선택해주세요")

                    .font(.H5MediumFont())
                    .foregroundColor(categoryValid ? .gray05 : .gray03)
                
                
                Image("icon_arrow_front_small")
                    .resizable()
                    .frame(width: 27, height: 27)
            })
            .buttonStyle(.plain)
            
        }
    }
    
    @ViewBuilder
    private func setDateComponent() -> some View {
        VStack(spacing: 25) {
            HStack {
                InquiryText(title: "시작일", isRequired: true)
                
                Spacer()
                
                Button(action: {
                    isActivePicker = true
                    isPickerStartData = true
                    date = viewModel.startDate
                }, label: {
                    Text(DateFormatter.koreanShort.string(from: viewModel.startDate))
                        .font(.H5MediumFont())
                        .foregroundColor(Calendar.current.isDateInToday(viewModel.startDate) ? .gray03 : .gray05)

                    Image("icon_arrow_front_small")
                        .resizable()
                        .frame(width: 27, height: 27)
                })
                .buttonStyle(.plain)
                
            }
            
            HStack {
                InquiryText(title: "종료일", isRequired: true)
                
                Spacer()
                
                Button(action: {
                    isActivePicker = true
                    isPickerStartData = false
                    date = viewModel.endDate
                }, label: {
                    Text(DateFormatter.koreanShort.string(from: viewModel.endDate))
                        .font(.H5MediumFont())
                        .foregroundColor(Calendar.current.isDateInToday(viewModel.endDate) ? .gray03 : .gray05)

                    Image("icon_arrow_front_small")
                        .resizable()
                        .frame(width: 27, height: 27)
                })
                .buttonStyle(.plain)
                
            }
        }
        
    }
    
    @ViewBuilder
    private func memoComponent() -> some View {
        VStack(alignment: .leading) {
            InquiryText(title: "다짐 및 도전 목표", isRequired: false)
            
            ZStack(alignment: .topLeading) {
                RoundedRectangle(cornerRadius: 6)
                    .foregroundColor(.gray01)
                    .frame(maxWidth: .infinity, maxHeight: 150)
                
                TextEditor(text: $viewModel.memo)
                    .font(.H4MediumFont())
                    .padding(.horizontal, 10)
                    .zIndex(0)
                    .colorMultiply(Color(.gray01))
                    .cornerRadius(6)
                
                
                if viewModel.memo.isEmpty {
                    Text("")
                        .font(.H5MediumFont())
                        .padding(.leading, 14)
                        .padding(.top, 16)
                        .foregroundColor(.gray02)
                        .cornerRadius(6)
                }
            }
            .clipShape(RoundedRectangle(cornerRadius: 6))
            .frame(maxWidth: .infinity, maxHeight: 150)
            .clipShape(RoundedRectangle(cornerRadius: 4))
        }
    }
    
    
    
}

#Preview {
    AddChallengeView()
}
